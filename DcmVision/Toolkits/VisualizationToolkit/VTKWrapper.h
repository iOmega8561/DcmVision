//
//  VTKWrapper.h
//  DICOM Image Processing
//
//  Created by Giuseppe Rocco on 18/02/25.
//
//  This Objective-C++ wrapper provides an interface for basic operations using the
//  Visualization Toolkit (VTK). It allows testing VTK functionality, creating simple
//  geometric shapes (e.g., a sphere), reconstructing 3D models from DICOM data, and
//  exporting the results.
//

#import <Foundation/Foundation.h>

/// @class VTKWrapper
/// @brief A simple Objective-C wrapper around the Visualization Toolkit (VTK) for
///        testing and generating basic geometric objects, as well as extracting
///        surfaces from DICOM volumes.
///
/// This class provides methods to check if VTK is correctly linked,
/// reconstruct a 3D model from DICOM slices using Marching Cubes,
/// and export these meshes to standard VTK-supported formats (e.g., OBJ).
@interface VTKWrapper : NSObject

/// @property cachePath
/// @brief The local directory path used by VTKWrapper to store generated files.
///
/// This directory is used to save exported VTK meshes. If not set, it defaults to
/// the system temporary directory.
@property (nonatomic, strong) NSString *cachePath;

/// @brief Checks if the VTK library is functional by creating and updating a simple
///        VTK pipeline.
///
/// This method initializes a basic VTK pipeline using a sphere source to ensure
/// that the library is linked and working correctly.
///
/// @return A boolean indicating whether VTK is functional.
- (BOOL)isVTKFunctional;

/// @brief Reads a directory of DICOM files, reconstructs a 3D surface using Marching Cubes,
///        and exports the resulting model as an OBJ file.
///
/// This method uses @c vtkDICOMImageReader to load a series of DICOM slices from
/// the specified directory. It then applies a Marching Cubes filter at the provided
/// threshold value to extract an isosurface. The result is saved in OBJ format
/// to @c cachePath.
///
/// @param dicomDir The filesystem path to a directory containing DICOM files.
/// @param fileName The base file name (without extension) for the OBJ file.
/// @param threshold The isosurface threshold used by Marching Cubes. Typically
///        a Hounsfield Unit for CT data.
/// @return The full filesystem path to the generated OBJ model, or nil on failure.
- (NSString *)generate3DModelFromDICOMDirectory:(NSString *)dicomDir
                                       fileName:(NSString *)fileName
                                      threshold:(double)threshold;

/// @brief Initializes a new instance of VTKWrapper with a specific output directory.
///
/// During construction, any necessary VTK modules or components can be verified.
/// If no valid cache path is provided, it defaults to the system temporary directory.
///
/// @param directoryURL A file URL pointing to the directory where exported VTK
///        files should be saved.
/// @return An instance of VTKWrapper, or nil if initialization fails.
- (instancetype)initWithCacheDirectoryURL:(NSURL *)directoryURL;

@end
