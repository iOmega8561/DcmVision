//
//  DCMTKWrapper.h
//  DICOM Conversion Utility
//
//  Created by Giuseppe Rocco on 18/02/25.
//
//  This Objective-C++ wrapper provides an interface for reading and converting
//  DICOM files using the DCMTK library. It exposes methods for converting
//  DICOM images to PNG format while handling caching and dictionary paths.
//

#import <Foundation/Foundation.h>

/// **DCMTKWrapper**
/// A wrapper around the DCMTK library to facilitate DICOM image processing.
/// Provides an interface to decode DICOM files and convert them to PNG format.
@interface DCMTKWrapper : NSObject

/// **Cache Path**
/// The directory where temporary output images are stored.
@property (nonatomic, strong) NSString *cachePath;

/// **DICOM Dictionary Path**
/// The path to the DICOM dictionary file required by DCMTK.
@property (nonatomic, strong) NSString *dicomDictPath;

/// **Convert a DICOM file to PNG format**
///
/// This method reads a DICOM image from the given file path, decodes it,
/// and saves it as a PNG file in the specified cache directory.
///
/// - Parameters:
///   - filePath: The full path to the DICOM file.
///   - fileName: The desired output file name (without extension).
///
/// - Returns: The full path to the generated PNG file, or `nil` if conversion fails.
- (NSString *)toPngFrom:(NSString *)filePath named:(NSString *)fileName;

/// **Initialize with a Custom Cache Directory**
///
/// Initializes the wrapper with a specific cache directory where output files will be stored.
///
/// - Parameters:
///   - directoryURL: The URL of the directory to use as a cache.
/// - Returns: An instance of `DCMTKWrapper`.
- (instancetype)initWithCacheDirectoryURL:(NSURL *)directoryURL;

@end
