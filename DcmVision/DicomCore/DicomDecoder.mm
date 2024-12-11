//
//  DicomDecoder.mm
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

#import <Foundation/Foundation.h>
#import "DicomDecoder.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"

#include "dcmtk/dcmimgle/dcmimage.h"
#include "dcmtk/dcmdata/dcdict.h"

#pragma clang diagnostic pop

@implementation DicomDecoder

- (NSString *)toPngFrom:(NSString *)filePath named:(NSString *)fileName {
    
    DicomImage *image = new DicomImage([filePath UTF8String]);
    
    if (image == nullptr || image->getStatus() != EIS_Normal) {
        NSLog(@"Error: Cannot open DICOM file %@", filePath);
        return nil;
    }
    
    NSString *outputPath = [_cachePath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.bmp", fileName]];
    
    if (image->writeBMP([outputPath UTF8String])) {
        return outputPath;
    }

    return nil;
}

- (instancetype) init {
    
    self = [super init];
    
    NSString *dictionaryPath = [ [NSBundle mainBundle]
                                    pathForResource:@"dicom"
                                    ofType:@"dic"];
    
    if (dictionaryPath) {
        _dicomDictPath = dictionaryPath;
        setenv("DCMDICTPATH", [_dicomDictPath UTF8String], 1);
                
    } else { NSLog(@"Error: dicom.dic file not found in bundle"); }
    
    return self;
}

- (instancetype) initWithCacheDirectoryURL:(NSURL *)directoryURL {
    self = [super init];
    
    _cachePath = directoryURL.path;
    
    return [self init];
}

@end

