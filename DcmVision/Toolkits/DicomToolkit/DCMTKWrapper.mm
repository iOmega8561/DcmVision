//
//  DCMTKWrapper.mm
//  DICOM Conversion Utility
//
//  Created by Giuseppe Rocco on 18/02/25.
//
//  Implementation of DCMTKWrapper using the DCMTK library for DICOM image processing.
//

#import "DCMTKWrapper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"

#include "dcmtk/dcmdata/dctk.h"
#include "dcmtk/dcmimgle/dcmimage.h"
#include "dcmtk/dcmdata/dcdict.h"
#include "dcmtk/dcmdata/dcdeftag.h"

#pragma clang diagnostic pop

@implementation DCMTKWrapper

#pragma mark - Conversion Methods

/// **Convert a DICOM file to BMP format**
///
/// This method reads a DICOM image from the given file path, decodes it, and saves it as a BMP file in the specified cache directory.
///
/// - Parameters:
///   - filePath: The full path to the DICOM file.
///   - fileName: The desired output file name (without extension).
/// - Returns: The full path to the generated BMP file, or `nil` if conversion fails.
- (NSString *)toBmpFrom:(NSString *)filePath named:(NSString *)fileName {
    // Create a new DICOM image from the file.
    DicomImage *image = new DicomImage([filePath UTF8String]);
    if (image == nullptr || image->getStatus() != EIS_Normal) {
        NSLog(@"❌ Error: Cannot open DICOM file %@", filePath);
        delete image; // Prevent memory leak.
        return nil;
    }

    // Construct output path.
    NSString *outputPath = [_cachePath stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"%@.bmp", fileName]];

    // Write image to BMP format.
    if (image->writeBMP([outputPath UTF8String])) {
        delete image;
        return outputPath;
    }

    // Cleanup if writing fails.
    delete image;
    return nil;
}

#pragma mark - Data Extraction Methods

/// **Extract Pixel Data from a DICOM file**
///
/// Returns the raw pixel data from the DICOM image, which can be passed to ITK for further processing.
///
/// - Parameter filePath: The full path to the DICOM file.
/// - Returns: An `NSData` object containing the pixel data, or `nil` if extraction fails.
- (NSData *)pixelDataFrom:(NSString *)filePath {
    DicomImage *image = new DicomImage([filePath UTF8String]);

    if (image == nullptr || image->getStatus() != EIS_Normal) {
        NSLog(@"❌ Error: Cannot open DICOM file %@", filePath);
        delete image; return nil;
    }

    unsigned long int width = image->getWidth();
    unsigned long int height = image->getHeight();
    
    // Retrieve 16-bit pixel data.
    const void *pixelData = image->getOutputData(16);
    if (!pixelData) {
        NSLog(@"❌ Error: Failed to retrieve pixel data from %@", filePath);
        delete image;
        return nil;
    }

    size_t dataSize = width * height * sizeof(uint16_t);
    NSData *data = [NSData dataWithBytes:pixelData length:dataSize];

    delete image; return data;
}

/// **Extract Metadata from a DICOM file**
///
/// Reads common DICOM tags such as **Patient Name, Patient ID, Study Date, Modality, and Instance Number**.
///
/// - Parameter filePath: The full path to the DICOM file.
/// - Returns: A dictionary containing the extracted metadata.
- (NSDictionary *)metadataFrom:(NSString *)filePath {
    
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
    DcmFileFormat fileFormat;

    if (fileFormat.loadFile([filePath UTF8String]).good()) {
        
        DcmDataset *dataset = fileFormat.getDataset();
        OFString value;

        // Extract Patient Name
        if (dataset->findAndGetOFString(DCM_PatientName, value).good()) {
            metadata[@"PatientName"] = [NSString stringWithUTF8String:value.c_str()];
        }
        
        // Extract Patient ID
        if (dataset->findAndGetOFString(DCM_PatientID, value).good()) {
            metadata[@"PatientID"] = [NSString stringWithUTF8String:value.c_str()];
        }
        
        // Extract Study Date
        if (dataset->findAndGetOFString(DCM_StudyDate, value).good()) {
            metadata[@"StudyDate"] = [NSString stringWithUTF8String:value.c_str()];
        }
        
        // Extract Modality
        if (dataset->findAndGetOFString(DCM_Modality, value).good()) {
            metadata[@"Modality"] = [NSString stringWithUTF8String:value.c_str()];
        }
        
        // Extract Patient Sex
        if (dataset->findAndGetOFString(DCM_PatientSex, value).good()) {
            metadata[@"PatientSex"] = [NSString stringWithUTF8String:value.c_str()];
        }

        // Extract Patient Age
        if (dataset->findAndGetOFString(DCM_PatientAge, value).good()) {
            metadata[@"PatientAge"] = [NSString stringWithUTF8String:value.c_str()];
        }

        // Extract Study Description
        if (dataset->findAndGetOFString(DCM_StudyDescription, value).good()) {
            metadata[@"StudyDescription"] = [NSString stringWithUTF8String:value.c_str()];
        }

        // Extract Slice Thickness
        Float64 sliceThickness = 0.0;
        if (dataset->findAndGetFloat64(DCM_SliceThickness, sliceThickness).good()) {
            metadata[@"SliceThickness"] = @(sliceThickness);
        }

        // Extract Convolution Kernel
        if (dataset->findAndGetOFString(DCM_ConvolutionKernel, value).good()) {
            metadata[@"ConvolutionKernel"] = [NSString stringWithUTF8String:value.c_str()];
        }

        // Extract Study Time
        if (dataset->findAndGetOFString(DCM_StudyTime, value).good()) {
            metadata[@"StudyTime"] = [NSString stringWithUTF8String:value.c_str()];
        }

        // Extract Manufacturer
        if (dataset->findAndGetOFString(DCM_Manufacturer, value).good()) {
            metadata[@"Manufacturer"] = [NSString stringWithUTF8String:value.c_str()];
        }

        // Extract Series Number (Se)
        Sint32 seriesNumber = 0;
        if (dataset->findAndGetSint32(DCM_SeriesNumber, seriesNumber).good()) {
            metadata[@"SeriesNumber"] = @(seriesNumber);
        }

        // Extract Total Number of Images (e.g. Im: 1/94)
        Sint32 imagesInAcquisition = 0;
        if (dataset->findAndGetSint32(DCM_ImagesInAcquisition, imagesInAcquisition).good()) {
            metadata[@"ImagesInAcquisition"] = @(imagesInAcquisition);
        }
        
        // Extract Instance Number
        int instanceNumber = 0;
        
        if (dataset->findAndGetSint32(DCM_InstanceNumber, instanceNumber).good()) {
            metadata[@"InstanceNumber"] = @(instanceNumber);
        }
        
    } else {
        NSLog(@"❌ Error: Cannot load DICOM file at %@", filePath);
        return nil;
    }

    return metadata;
}

/// **Check if a file is a valid DICOM file**
///
/// Attempts to load the file as a DICOM image and checks its status.
///
/// - Parameter filePath: The full path to the file.
/// - Returns: `YES` if the file is a valid DICOM file, `NO` otherwise.
- (BOOL)isValidDICOM:(NSString *)filePath {
    DicomImage *image = new DicomImage([filePath UTF8String]);

    BOOL valid = (image != nullptr && image->getStatus() == EIS_Normal);
    
    delete image; return valid;
}

#pragma mark - Initialization

/// **Default Initializer**
///
/// Initializes the wrapper and attempts to locate the `dicom.dic` dictionary file.
/// If found, it sets the environment variable `DCMDICTPATH` for DCMTK.
///
/// - Returns: An initialized `DCMTKWrapper` instance.
- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        // Set a default cache path if one isn’t provided.
        if (!_cachePath) {
            _cachePath = NSTemporaryDirectory();
        }
        
        // Locate the DICOM dictionary file in the app bundle.
        NSString *dictionaryPath = [[NSBundle mainBundle] pathForResource:@"dicom" ofType:@"dic"];
        
        if (dictionaryPath) {
            _dicomDictPath = dictionaryPath;
            setenv("DCMDICTPATH", [_dicomDictPath UTF8String], 1);
        } else {
            NSLog(@"❌ Error: dicom.dic file not found in bundle");
            return nil;
        }
    }
    
    return self;
}

/// **Initialize with a Custom Cache Directory**
///
/// Initializes the wrapper with a specific cache directory for storing output files.
///
/// - Parameter directoryURL: The URL of the directory to use as a cache.
/// - Returns: An instance of `DCMTKWrapper`.
- (instancetype)initWithCacheDirectoryURL:(NSURL *)directoryURL {
    
    self = [super init];

    if (self) {
        _cachePath = directoryURL.path;
    }

    return [self init]; // Call the default initializer to set up the dictionary path.
}

@end
