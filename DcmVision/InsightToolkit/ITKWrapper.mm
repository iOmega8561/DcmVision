//
//  ITKWrapper.mm
//  DICOM Image Processing
//
//  Created by Giuseppe Rocco on 18/02/25.
//
//  Implementation of ITKWrapper using the ITK library for DICOM image handling.
//

#import <Foundation/Foundation.h>
#import "ITKWrapper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"

#include <itkImage.h>
#include <itkImageFileReader.h>
#include <itkImageFileWriter.h>
#include <itkImageSeriesReader.h>
#include <itkGDCMImageIOFactory.h>
#include <itkMetaImageIOFactory.h>
#include <itkNiftiImageIOFactory.h>
#include <itkPNGImageIOFactory.h>
#include <itkTIFFImageIOFactory.h>
#include <itkJPEGImageIOFactory.h>

#pragma clang diagnostic pop

/// @typedef PixelType
/// @brief Defines the underlying pixel data type (16-bit unsigned) for the 3D volume.
using PixelType = unsigned short;

/// @const Dimension
/// @brief The dimensionality of the volume (3 for 3D images).
constexpr unsigned int Dimension = 3;

/// @typedef ImageType
/// @brief An ITK image type used to represent a 3D volume of PixelType pixels.
using ImageType = itk::Image<PixelType, Dimension>;

/// @brief A private extension that stores the loaded ITK 3D volume.
@interface ITKWrapper ()
{
    /// @var _volume
    /// An ITK image type used to represent a 3D volume of PixelType pixels.
    ImageType::Pointer _volume;
    
    /// @var _defaultVolumeName
    /// A string fallback for the exported volume file name
    NSString *_defaultVolumeName;
}
@end

@implementation ITKWrapper

/// @brief Determines whether the specified file is a valid DICOM by attempting to load it.
///
/// This checks that the file can be opened by ITK’s DICOM reading mechanism.
/// If this fails, an error is logged, and NO is returned.
///
/// @param filePath The full file-system path to the DICOM file.
/// @return YES if the file is valid; NO if it fails to load.
- (BOOL)isValidDICOM:(NSString *)filePath {
    
    using LocalImageType = itk::Image<unsigned short, 2>;
    using ReaderType = itk::ImageFileReader<LocalImageType>;
    
    auto reader = ReaderType::New();
    reader->SetFileName([filePath UTF8String]);
    
    try {
        reader->Update();
    } catch (itk::ExceptionObject &ex) {
        NSLog(@"❌ Error loading DICOM: %s", ex.what());
        return NO;
    }
    
    NSLog(@"✅ Successfully loaded DICOM file: %@", filePath);
    return YES;
}

/// @brief Creates a 3D volume from a sorted list of DICOM slices.
///
/// If the update is successful, the slices are combined into a single ITK volume
/// and stored in the _volume member. This volume can then be exported or processed
/// further.
///
/// @param sortedFilePaths An array of fully qualified file paths (NSString),
///        sorted according to slice order.
/// @return YES if the volume was reconstructed; NO if reading failed.
- (BOOL)loadDICOMSeriesWithPaths:(NSArray<NSString *> *)sortedFilePaths {
    
    std::vector<std::string> fileNames;
    for (NSString *path in sortedFilePaths) {
        fileNames.push_back([path UTF8String]);
    }
    
    using ReaderType = itk::ImageSeriesReader<ImageType>;
    auto reader = ReaderType::New();
    reader->SetFileNames(fileNames);
    
    try {
        reader->Update();
    } catch (itk::ExceptionObject &ex) {
        NSLog(@"❌ Error loading DICOM series: %s", ex.what());
        return NO;
    }
    
    _volume = reader->GetOutput();
    NSLog(@"✅ Successfully loaded DICOM series as 3D volume.");
    return YES;
}

/// @brief Writes the currently loaded 3D volume to a default MetaImage file.
///
/// If no volume is loaded (e.g., no call to loadDICOMSeriesWithPaths: has succeeded),
/// this method logs an error and returns nil. Otherwise, the output is saved to the
/// @c cachePath directory with the provided filename or the fallback "ITK_Volume_Export.mha".
///
/// @param fileName The file name to be used for the new volume that will be exported
/// @return The full path of the exported .mha file, or nil if exporting failed.
- (NSString *)exportVolumeWithName:(NSString *)fileName {
    
    if (!_volume) {
        NSLog(@"❌ No volume loaded to export.");
        return nil;
    }
    
    if (fileName == nil) {
        fileName = _defaultVolumeName;
    }
    
    NSString *outputPath = [_cachePath stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"%@.mha", fileName]];
    
    using WriterType = itk::ImageFileWriter<ImageType>;
    auto writer = WriterType::New();
    writer->SetFileName([outputPath UTF8String]);
    writer->SetInput(_volume);
    
    try {
        writer->Update();
    } catch (itk::ExceptionObject &ex) {
        NSLog(@"❌ Error exporting volume: %s", ex.what());
        return nil;
    }
    
    NSLog(@"✅ Successfully exported 3D volume to %@", outputPath);
    return outputPath;
}

/// @brief Registers built-in IO factories and initializes the wrapper with a given cache directory.
///
/// This method sets up the internal @c cachePath property and prepares ITK
/// to recognize multiple image formats. If the directory is invalid or write-protected,
/// writing and reading may fail.
///
/// @param directoryURL The file URL to the desired cache/output directory.
/// @return An initialized ITKWrapper instance.
- (instancetype)initWithCacheDirectoryURL:(NSURL *)directoryURL {
    
    self = [super init];
    
    if (self) {
        _cachePath = directoryURL.path;
        _defaultVolumeName = @"ITK_Volume_Export";
        
        itk::GDCMImageIOFactory::RegisterOneFactory();
        itk::MetaImageIOFactory::RegisterOneFactory();
        itk::NiftiImageIOFactory::RegisterOneFactory();
        itk::PNGImageIOFactory::RegisterOneFactory();
        itk::TIFFImageIOFactory::RegisterOneFactory();
        itk::JPEGImageIOFactory::RegisterOneFactory();
    }
    
    return self;
}

@end
