//
//  dmctk-wrapper.mm
//  DicomTest
//
//  Created by Giuseppe Rocco on 09/12/24.
//

#import <Foundation/Foundation.h>
#import "DcmDecoder.h"
#include "dcmtk/dcmimgle/dcmimage.h"
#include "dcmtk/dcmdata/dcdict.h"
// DCMTK includes for decoding images

@implementation DcmDecoder

+ (NSString *)toPng:(NSString *)filePath {
    
    // Set the path to the dicom.dic file in the app bundle
    NSString *dictionaryPath = [[NSBundle mainBundle] pathForResource:@"dicom" ofType:@"dic"];
    
    NSLog(@"File path: %@", dictionaryPath);
    
    if (dictionaryPath) {
        setenv("DCMDICTPATH", [dictionaryPath UTF8String], 1);
    } else {
        NSLog(@"Error: dicom.dic file not found in bundle");
        return nil;
    }
    
    // Convert NSString to C++ string
    const char *cFilePath = [filePath UTF8String];

    // Use DCMTK to read the DICOM file
    DicomImage *image = new DicomImage(cFilePath);
    
    if (image == nullptr || image->getStatus() != EIS_Normal) {
        NSLog(@"Error: Cannot open DICOM file %@", filePath);
        return nil;
    }

    // Save the decoded image to a temporary location
    NSString *outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"output.bmp"];
    
    if (image->writeBMP([outputPath UTF8String])) {
        return outputPath;
    }

    return nil;
}

@end

