//
//  DCMTKWrapper.h
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

@interface DCMTKWrapper : NSObject

@property (nonatomic, strong) NSString *cachePath;

@property (nonatomic, strong) NSString *dicomDictPath;

// Expose a method to read and decode a DICOM file.
- (NSString *)toPngFrom:(NSString *)filePath named:(NSString *)fileName;

- (instancetype) initWithCacheDirectoryURL:(NSURL *)directoryURL;

@end
