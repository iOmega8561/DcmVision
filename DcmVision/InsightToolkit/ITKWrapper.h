//
//  ITKWrapper.h
//  DICOM Image Processing
//
//  Created by Giuseppe Rocco on 18/02/25.
//
//  This Objective-C++ wrapper provides an interface for reading and handling
//  DICOM files using the ITK (Insight Toolkit) library.
//

#import <Foundation/Foundation.h>

/// @class ITKWrapper
/// @brief A simple Objective-C wrapper around the Insight Toolkit (ITK) for
///        loading and exporting 3D volumes from DICOM data.
///
/// This class simplifies common operations with ITK, such as checking whether a
/// file is a valid DICOM and reconstructing a 3D volume from a series of DICOM
/// slices. After loading, the volume can be exported in standard ITK-supported
/// formats (e.g., MetaImage).
@interface ITKWrapper : NSObject

/// @property cachePath
/// @brief The local directory path used by ITKWrapper to store intermediate
///        or output files.
///
/// For instance, if you export the 3D volume, the resulting file is placed in
/// this directory. Ensure that your application has write permissions here.
@property (nonatomic, strong) NSString *cachePath;

/// @brief Checks whether a given file path points to a valid DICOM file.
///
/// This method uses ITK's DICOM reading capabilities to open the file and verify
/// its contents. If the file is invalid or cannot be opened, the method returns
/// NO.
///
/// @param filePath The full path to a single DICOM file on disk.
/// @return A boolean indicating whether the file is recognized as a valid DICOM.
- (BOOL)isValidDICOM:(NSString *)filePath;

/// @brief Loads a sorted series of DICOM slices and reconstructs a 3D volume.
///
/// The caller must provide an NSArray of file paths that have already been
/// sorted (usually by InstanceNumber or Slice Location). If loading is successful,
/// an internal 3D volume is created for later export.
///
/// @param sortedFilePaths An array of full paths (NSString) to DICOM slices,
///        already sorted in the correct anatomical order.
/// @return A boolean indicating whether the volume was loaded successfully.
- (BOOL)loadDICOMSeriesWithPaths:(NSArray<NSString *> *)sortedFilePaths;

/// @brief Exports the currently loaded 3D volume to disk.
///
/// The resulting file is saved into @c cachePath, typically in MetaImage format
/// (.mha). If no volume has been loaded, this method returns nil.
///
/// @param fileName The file name to be used for the new volume that will be exported
/// @return The full file path of the exported volume, or nil if export failed.
- (NSString *)exportVolumeWithName:(NSString *)fileName;

/// @brief Initializes a new instance of ITKWrapper with a specific cache directory.
///
/// During construction, various ITK I/O factories are registered (e.g., GDCM, NIfTI,
/// etc.) to ensure that DICOM and other image formats can be read/written.
///
/// @param directoryURL A file URL pointing to the directory to be used for caching
///        and output.
/// @return An instance of ITKWrapper, or nil if initialization failed.
- (instancetype)initWithCacheDirectoryURL:(NSURL *)directoryURL;

@end
