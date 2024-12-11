//
//  DicomDecoder.mm
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

#import <Foundation/Foundation.h>
#import "DicomDecoder.h"
#include "dcmtk/dcmimgle/dcmimage.h"
#include "dcmtk/dcmdata/dcdict.h"

@implementation DicomDecoder

- (NSString *)toPngFrom:(NSString *)filePath named:(NSString *)fileName {
    
    const char *cFilePath = [filePath UTF8String];

    DicomImage *image = new DicomImage(cFilePath);
    
    if (image == nullptr || image->getStatus() != EIS_Normal) {
        NSLog(@"Error: Cannot open DICOM file %@", filePath);
        return nil;
    }

    NSString *outputPath = [NSTemporaryDirectory()
                            stringByAppendingPathComponent: [NSString
                                                             stringWithFormat:@"%@.bmp", fileName]];
    
    if (image->writeBMP([outputPath UTF8String])) {
        return outputPath;
    }

    return nil;
}

- (instancetype) init {
    
    self = [super init];
    
    NSString *dictionaryPath = [[NSBundle mainBundle]
                                  pathForResource:@"dicom"
                                  ofType:@"dic"];
    
    if (self && dictionaryPath) {
        _dicomDictPath = dictionaryPath;
        setenv("DCMDICTPATH", [_dicomDictPath UTF8String], 1);
        
    } else if (self) {
        NSLog(@"Error: dicom.dic file not found in bundle");
    }
    
    return self;
}

@end

