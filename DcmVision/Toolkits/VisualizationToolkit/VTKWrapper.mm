//
//  VTKWrapper.mm
//  DICOM Image Processing
//
//  Created by Giuseppe Rocco on 18/02/25.
//
//  This Objective-C++ implementation provides basic VTK functionalities, including
//  verifying that VTK is properly linked, generating simple geometrical objects, and
//  extracting surfaces from DICOM datasets via Marching Cubes. The common logic for
//  exporting vtkPolyData to an OBJ file is encapsulated in a private helper method.
//

#import <Foundation/Foundation.h>
#import "VTKWrapper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"

#import <vtkSmartPointer.h>
#import <vtkSphereSource.h>
#import <vtkOBJWriter.h>
#import <vtkDICOMImageReader.h>
#import <vtkMarchingCubes.h>
#import <vtkPolyData.h>

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
///        and exports the resulting mesh as an OBJ file.
/// @param dicomDir Filesystem path to a directory containing DICOM files.
/// @param fileName The base file name (without extension) for the OBJ output.
/// @param threshold The isosurface threshold used by Marching Cubes.
///        For CT data in Hounsfield units, a value such as ~300 might capture bone.
/// @return The full filesystem path to the generated OBJ file, or nil on error.
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
        
        // 4) Export the polydata using the common export method.
        return [self exportPolyData:polyData withFileName:fileName];
        
    } @catch (NSException *exception) {
        NSLog(@"❌ Error generating 3D model from DICOM: %@", exception);
        return nil;
    }
}

/// @brief Helper method to export vtkPolyData as an OBJ file.
/// @param polyData A pointer to the vtkPolyData to be exported.
/// @param fileName The base file name (without extension) to use for the exported file.
/// @return The full filesystem path to the generated OBJ file, or nil on error.
- (NSString *)exportPolyData:(vtkPolyData *)polyData withFileName:(NSString *)fileName {
    
    @try {
        
        // Define the output file path based on the cachePath property.
        NSString *outputPath = [_cachePath stringByAppendingPathComponent:
                                [NSString stringWithFormat:@"%@.obj", fileName]];
        std::string stdFilePath = [outputPath UTF8String];
        
        // Create and configure the OBJ writer.
        vtkSmartPointer<vtkOBJWriter> writer = vtkSmartPointer<vtkOBJWriter>::New();
        writer->SetFileName(stdFilePath.c_str());
        writer->SetInputData(polyData);
        writer->Write();
        
        NSLog(@"✅ Successfully exported OBJ to %@", outputPath);
        return outputPath;
        
    } @catch (NSException *exception) {
        NSLog(@"❌ Error exporting vtkPolyData to OBJ: %@", exception);
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
