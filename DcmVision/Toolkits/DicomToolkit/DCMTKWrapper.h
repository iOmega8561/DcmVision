//
//  Copyright (C) 2025  Giuseppe Rocco
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//  ----------------------------------------------------------------------
//
//  DCMTKWrapper.h
//  DICOM Conversion Utility
//
//  Created by Giuseppe Rocco on 18/02/25.
//
//  This Objective-C++ wrapper provides an interface for reading and converting
//  DICOM files using the DCMTK library. It exposes methods for converting
//  DICOM images to BMP format while handling caching and dictionary paths.
//

#import <Foundation/Foundation.h>

/// **DCMTKWrapper**
/// A wrapper around the DCMTK library to facilitate DICOM image processing.
/// Provides an interface to decode DICOM files, extract metadata, and convert them to various formats.
@interface DCMTKWrapper : NSObject

/// **Cache Path**
/// The directory where temporary output images are stored.
@property (nonatomic, strong) NSString *cachePath;

/// **DICOM Dictionary Path**
/// The path to the DICOM dictionary file required by DCMTK.
@property (nonatomic, strong) NSString *dicomDictPath;

/// **Convert a DICOM file to BMP format**
/// This method reads a DICOM image from the given file path, decodes it,
/// and saves it as a BMP file in the specified cache directory.
///
/// - Parameters:
///   - filePath: The full path to the DICOM file.
///   - fileName: The desired output file name (without extension).
///
/// - Returns: The full path to the generated BMP file, or `nil` if conversion fails.
- (NSString *)toBmpFrom:(NSString *)filePath named:(NSString *)fileName;

/// **Extract Pixel Data from a DICOM file**
/// Returns the raw pixel data from the DICOM image which can be passed to ITK for further processing.
///
/// - Parameter filePath: The full path to the DICOM file.
/// - Returns: An NSData object containing the pixel data, or `nil` if extraction fails.
- (NSData *)pixelDataFrom:(NSString *)filePath;

/// **Extract Metadata from a DICOM file**
/// Reads common DICOM tags such as Patient Name, Patient ID, Study Date, Modality, and Instance Number.
///
/// - Parameter filePath: The full path to the DICOM file.
/// - Returns: A dictionary containing the extracted metadata.
- (NSDictionary *)metadataFrom:(NSString *)filePath;

/// **Check if a file is a valid DICOM file**
/// Attempts to load the file as a DICOM image and checks its status.
///
/// - Parameter filePath: The full path to the file.
/// - Returns: YES if the file is a valid DICOM file, NO otherwise.
- (BOOL)isValidDICOM:(NSString *)filePath;

/// **Initialize with a Custom Cache Directory**
/// Initializes the wrapper with a specific cache directory for storing output files.
///
/// - Parameter directoryURL: The URL of the directory to use as a cache.
/// - Returns: An instance of `DCMTKWrapper`.
- (instancetype)initWithCacheDirectoryURL:(NSURL *)directoryURL;

@end
