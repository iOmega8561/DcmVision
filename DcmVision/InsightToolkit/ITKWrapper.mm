//
//  ITKWrapper.h
//  DcmVision
//
//  Created by Giuseppe Rocco on 18/02/25.
//

#import <Foundation/Foundation.h>
#import <iostream>

#import "ITKWrapper.h"

#ifdef __cplusplus
  #include <itkImage.h>
  #include <itkImageFileReader.h>
  #include <itkGDCMImageIOFactory.h>
  #include <itkMetaImageIOFactory.h>
  #include <itkNiftiImageIOFactory.h>
  #include <itkPNGImageIOFactory.h>
  #include <itkTIFFImageIOFactory.h>
  #include <itkJPEGImageIOFactory.h>
#endif

@implementation ITKWrapper

- (void)loadDICOMat:(NSString *)filePath {
    
    using ImageType = itk::Image<unsigned short, 2>;
    using ReaderType = itk::ImageFileReader<ImageType>;

    auto reader = ReaderType::New();
    reader->SetFileName([filePath UTF8String]);

    try {
        reader->Update();
        NSLog(@"✅ Successfully loaded DICOM file: %@", filePath);
    } catch (itk::ExceptionObject & err) {
        std::cerr << "❌ ITK Error: " << err << std::endl;
    }
}

- (instancetype) init {
    
    self = [super init];
    
    #ifdef __cplusplus
    itk::GDCMImageIOFactory::RegisterOneFactory();
    itk::MetaImageIOFactory::RegisterOneFactory();
    itk::NiftiImageIOFactory::RegisterOneFactory();
    itk::PNGImageIOFactory::RegisterOneFactory();
    itk::TIFFImageIOFactory::RegisterOneFactory();
    itk::JPEGImageIOFactory::RegisterOneFactory();
    #endif
    
    return self;
}

- (instancetype) initWithCacheDirectoryURL:(NSURL *)directoryURL {
    self = [super init];
    
    _cachePath = directoryURL.path;
    
    return [self init];
}

@end
