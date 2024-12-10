//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

@interface DcmDecoder : NSObject

// Expose a method to read and decode a DICOM file.
+ (NSString *)toPng:(NSString *)filePath;

@end
