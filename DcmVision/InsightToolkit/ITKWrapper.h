//
//  ITKWrapper.h
//  DcmVision
//
//  Created by Giuseppe Rocco on 18/02/25.
//

#import <Foundation/Foundation.h>

@interface ITKWrapper : NSObject

@property (nonatomic, strong) NSString *cachePath;

// Expose a method to load a DICOM file
- (void)loadDICOMat:(NSString *)filePath;

- (instancetype) initWithCacheDirectoryURL:(NSURL *)directoryURL;

@end
