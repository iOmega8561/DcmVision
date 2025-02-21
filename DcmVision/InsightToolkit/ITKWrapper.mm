//
//  ITKWrapper.mm
//  DICOM Image Processing
//
//  Created by Giuseppe Rocco on 18/02/25.
//
//  Implementation of ITKWrapper using the ITK library for DICOM image handling.
//

#import <Foundation/Foundation.h>
#import <iostream>

#import "ITKWrapper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"

#include <itkImage.h>
#include <itkImageFileReader.h>
#include <itkGDCMImageIOFactory.h>
#include <itkMetaImageIOFactory.h>
#include <itkNiftiImageIOFactory.h>
#include <itkPNGImageIOFactory.h>
#include <itkTIFFImageIOFactory.h>
#include <itkJPEGImageIOFactory.h>

#pragma clang diagnostic pop

@implementation ITKWrapper

/// **Load a DICOM File**
///
/// This method utilizes ITK's `ImageFileReader` to load a DICOM file and process it.
/// The file is opened and decoded, and its metadata is logged.
///
/// - Parameter filePath: The full path to the DICOM file.
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

/// **Default Initializer**
///
/// - Registers ITK’s DICOM I/O factories to ensure proper file reading.
/// - Returns: An initialized `ITKWrapper` instance.
- (instancetype)init {
    
    self = [super init];
    
    // ✅ Register ITK I/O Factories to Enable DICOM Reading
    itk::GDCMImageIOFactory::RegisterOneFactory();
    itk::MetaImageIOFactory::RegisterOneFactory();
    itk::NiftiImageIOFactory::RegisterOneFactory();
    itk::PNGImageIOFactory::RegisterOneFactory();
    itk::TIFFImageIOFactory::RegisterOneFactory();
    itk::JPEGImageIOFactory::RegisterOneFactory();
    
    return self;
}

/// **Initialize ITKWrapper with a Custom Cache Directory**
///
/// - Parameter directoryURL: The URL of the directory to use as a cache.
/// - Returns: An initialized `ITKWrapper` instance.
- (instancetype)initWithCacheDirectoryURL:(NSURL *)directoryURL {
    self = [super init];
    
    _cachePath = directoryURL.path;
    
    return [self init]; // Call the default initializer
}

@end
