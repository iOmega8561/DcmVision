//
//  DcmDecoder.h
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

@interface DcmDecoder : NSObject

@property (nonatomic, strong) NSString *dicomDictPath;

// Expose a method to read and decode a DICOM file.
- (NSString *)toPngFrom:(NSString *)filePath;

@end
