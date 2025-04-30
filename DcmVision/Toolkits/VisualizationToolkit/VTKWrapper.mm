//
//  VTKWrapper.mm
//  DICOM Image Processing
//
//  Created by Giuseppe Rocco on 18/02/25.
//
//  This Objective-C++ implementation provides basic VTK functionalities, including
//  verifying that VTK is properly linked, generating simple geometrical objects, and
//  extracting surfaces from DICOM datasets via Marching Cubes. The common logic for
//  exporting vtkPolyData to a PLY file is encapsulated in a private helper method.
//

#import <Foundation/Foundation.h>
#import "VTKWrapper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"

#import <vtkSmartPointer.h>
#import <vtkSphereSource.h>
#import <vtkPLYWriter.h>
#import <vtkDICOMImageReader.h>
#import <vtkMarchingCubes.h>
#import <vtkPolyData.h>
#import <vtkCleanPolyData.h>
#import <vtkDecimatePro.h>
#import <vtkTransform.h>
#import <vtkTransformPolyDataFilter.h>

#pragma clang diagnostic pop

@implementation VTKWrapper

/// @brief Checks if VTK is functional by generating a small sphere and verifying
///        that it has a nonzero number of points.
/// @return YES if VTK works properly; NO otherwise.
- (BOOL)isVTKFunctional {
    
    @try {
        
        vtkSmartPointer<vtkSphereSource> sphereSource = vtkSmartPointer<vtkSphereSource>::New();
        sphereSource->SetThetaResolution(10);
        sphereSource->SetPhiResolution(10);
        sphereSource->Update();
        
        vtkSmartPointer<vtkPolyData> sphereData = sphereSource->GetOutput();
        return (sphereData->GetNumberOfPoints() > 0);
        
    } @catch (NSException *exception) { return NO; }
}

/// @brief Reads a directory of DICOM files, reconstructs a 3D isosurface using Marching Cubes,
///        and exports the resulting mesh as a PLY file.
/// @param dicomDir Filesystem path to a directory containing DICOM files.
/// @param fileName The base file name (without extension) for the PLY output.
/// @param threshold The isosurface threshold used by Marching Cubes.
///        For CT data in Hounsfield units, a value such as ~300 might capture bone.
/// @return The full filesystem path to the generated PLY file, or nil on error.
- (NSString *)generate3DModelFromDICOMDirectory:(NSString *)dicomDir
                                       fileName:(NSString *)fileName
                                      threshold:(double)threshold {
    @try {
        
        // 1) Read the DICOM dataset.
        vtkSmartPointer<vtkDICOMImageReader> reader = vtkSmartPointer<vtkDICOMImageReader>::New();
        reader->SetDirectoryName([dicomDir UTF8String]);
        reader->Update();
        
        // 2) Apply Marching Cubes to extract the isosurface.
        vtkSmartPointer<vtkMarchingCubes> mc = vtkSmartPointer<vtkMarchingCubes>::New();
        mc->SetInputConnection(reader->GetOutputPort());
        mc->SetValue(0, threshold);
        mc->ComputeNormalsOn();
        mc->Update();
        
        // 3) Retrieve the resulting 3D model (polydata).
        vtkSmartPointer<vtkPolyData> polyData = mc->GetOutput();
        
        // 4) Process the polyData for better compatibility with Vision Pro
        vtkSmartPointer<vtkPolyData> processedPolyData = [self processPolyData:polyData];
        
        // 5) Export the clean polydata using the common export method.
        return [self exportPolyData:processedPolyData withFileName:fileName];
        
    } @catch (NSException *exception) {
        NSLog(@"❌ Error generating 3D model from DICOM: %@", exception);
        return nil;
    }
}

/// @brief  Reduce polygon count and uniformly scale a mesh for efficient display on Apple Vision Pro.
/// @details This routine applies a mesh decimation to cut the triangle count in half,
///          then scales the model down to 10% of its original size, and finally cleans up
///          any unused points or degenerate cells. The result is a lighter-weight, correctly
///          sized vtkPolyData that’s ready for immersive display.
/// @param  polyData The input vtkPolyData to process. Must be non-null.
/// @return A new vtkSmartPointer<vtkPolyData> containing the decimated, scaled, and cleaned mesh.
///         Returns nullptr if an error occurs during processing.
- (vtkSmartPointer<vtkPolyData>)processPolyData:(vtkSmartPointer<vtkPolyData>)polyData {
    
    if (!polyData) {
        NSLog(@"⚠️ processPolyData: received null input");
        return nullptr;
    }

    // 1) Decimate: reduce to 50% of original polys while preserving topology.
    vtkSmartPointer<vtkDecimatePro> decimator = vtkSmartPointer<vtkDecimatePro>::New();
    decimator->SetInputData(polyData);
    decimator->SetTargetReduction(0.5);
    decimator->PreserveTopologyOn();
    decimator->Update();

    // 2) Uniform scale: shrink the mesh to 10% in all dimensions
    vtkSmartPointer<vtkTransform> transform = vtkSmartPointer<vtkTransform>::New();
    transform->Scale(0.1, 0.1, 0.1);

    vtkSmartPointer<vtkTransformPolyDataFilter> transformFilter = vtkSmartPointer<vtkTransformPolyDataFilter>::New();
    transformFilter->SetInputConnection(decimator->GetOutputPort());
    transformFilter->SetTransform(transform);
    transformFilter->Update();

    // 3) Clean up: merge duplicate points and remove unused data
    vtkSmartPointer<vtkCleanPolyData> cleaner = vtkSmartPointer<vtkCleanPolyData>::New();
    cleaner->SetInputConnection(transformFilter->GetOutputPort());
    cleaner->Update();

    return cleaner->GetOutput();
}


/// @brief Helper method to export vtkPolyData as a PLY file.
/// @param polyData A pointer to the vtkPolyData to be exported.
/// @param fileName The base file name (without extension) to use for the exported file.
/// @return The full filesystem path to the generated PLY file, or nil on error.
- (NSString *)exportPolyData:(vtkPolyData *)polyData withFileName:(NSString *)fileName {
    
    @try {
        
        // Define the output file path based on the cachePath property.
        NSString *outputPath = [_cachePath stringByAppendingPathComponent:
                                [NSString stringWithFormat:@"%@.ply", fileName]];
        std::string stdFilePath = [outputPath UTF8String];
        
        // Create and configure the PLY writer.
        vtkSmartPointer<vtkPLYWriter> writer = vtkSmartPointer<vtkPLYWriter>::New();
        writer->SetFileName(stdFilePath.c_str());
        writer->SetInputData(polyData);
        writer->Write();
        
        NSLog(@"✅ Successfully exported PLY to %@", outputPath);
        return outputPath;
        
    } @catch (NSException *exception) {
        NSLog(@"❌ Error exporting vtkPolyData to PLY: %@", exception);
        return nil;
    }
}

/// @brief Initializes a new instance of VTKWrapper with a specific output directory.
/// @param directoryURL A file URL pointing to the directory where exported VTK
///        files should be saved.
/// @return An instance of VTKWrapper, or nil if initialization fails.
- (instancetype)initWithCacheDirectoryURL:(NSURL *)directoryURL {
    
    self = [super init];
    
    if (self) {
    
        // If a valid directory URL is provided, use its path;
        // otherwise, default to NSTemporaryDirectory.
        if (directoryURL) {
            _cachePath = directoryURL.path;
        }
        
        if (!_cachePath) {
            _cachePath = NSTemporaryDirectory();
        }
    }
    return self;
}

@end
