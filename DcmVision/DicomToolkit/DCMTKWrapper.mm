//
//  DCMTKWrapper.mm
//  DICOM Conversion Utility
//
//  Created by Giuseppe Rocco on 18/02/25.
//
//  Implementation of DCMTKWrapper using the DCMTK library for DICOM image processing.
//

#import <Foundation/Foundation.h>
#import "DCMTKWrapper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"

#include "dcmtk/dcmimgle/dcmimage.h"
#include "dcmtk/dcmdata/dcdict.h"

#pragma clang diagnostic pop

@implementation DCMTKWrapper

/// **Convert a DICOM file to PNG format**
///
/// This method uses `DicomImage` from DCMTK to read and decode a DICOM image.
/// If successful, the image is saved as a BMP file in the cache directory.
///
/// - Parameters:
///   - filePath: The full path to the DICOM file.
///   - fileName: The desired output file name (without extension).
///
/// - Returns: The full path to the generated PNG file, or `nil` if conversion fails.
- (NSString *)toPngFrom:(NSString *)filePath named:(NSString *)fileName {
    // Create a new DICOM image from the file
    DicomImage *image = new DicomImage([filePath UTF8String]);
    
    // Ensure the image was loaded successfully
    if (image == nullptr || image->getStatus() != EIS_Normal) {
        NSLog(@"❌ Error: Cannot open DICOM file %@", filePath);
        delete image; // Prevent memory leak
        return nil;
    }
    
    // Construct output path
    NSString *outputPath = [_cachePath stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"%@.bmp", fileName]];
    
    // Write image to BMP format
    if (image->writeBMP([outputPath UTF8String])) {
        delete image; // Clean up allocated memory
        return outputPath;
    }
    
    // Cleanup
    delete image;
    return nil;
}

/// **Default Initializer**
///
/// Initializes the wrapper and attempts to locate the `dicom.dic` dictionary file.
/// If found, it sets the environment variable `DCMDICTPATH` for DCMTK.
///
/// - Returns: An initialized `DCMTKWrapper` instance.
- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        // Locate the DICOM dictionary file in the app bundle
        NSString *dictionaryPath = [[NSBundle mainBundle] pathForResource:@"dicom" ofType:@"dic"];
        
        if (dictionaryPath) {
            _dicomDictPath = dictionaryPath;
            setenv("DCMDICTPATH", [_dicomDictPath UTF8String], 1);
        } else {
            NSLog(@"❌ Error: dicom.dic file not found in bundle");
        }
    }
    
    return self;
}

/// **Initialize with a Custom Cache Directory**
///
/// Initializes the wrapper with a specific cache directory for storing output files.
///
/// - Parameters:
///   - directoryURL: The URL of the directory to use as a cache.
/// - Returns: An instance of `DCMTKWrapper`.
- (instancetype)initWithCacheDirectoryURL:(NSURL *)directoryURL {
    
    self = [super init];
    
    if (self) {
        _cachePath = directoryURL.path;
    }
    
    return [self init]; // Call the default initializer
}

@end
