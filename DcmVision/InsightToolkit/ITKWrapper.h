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

/// **ITKWrapper**
///
/// A wrapper around the **ITK library** to facilitate **DICOM image loading**.
/// This class registers ITK’s DICOM I/O factories and provides methods
/// for reading DICOM files.
@interface ITKWrapper : NSObject

/// **Cache Path**
///
/// The directory where temporary files related to DICOM processing are stored.
@property (nonatomic, strong) NSString *cachePath;

/// **Load a DICOM File**
///
/// This method reads a DICOM image from the given file path and processes it.
///
/// - Parameter filePath: The full path to the DICOM file.
- (void)loadDICOMat:(NSString *)filePath;

/// **Initialize ITKWrapper with a Custom Cache Directory**
///
/// - Parameter directoryURL: The URL of the directory to use as a cache.
/// - Returns: An initialized `ITKWrapper` instance.
- (instancetype)initWithCacheDirectoryURL:(NSURL *)directoryURL;

@end
