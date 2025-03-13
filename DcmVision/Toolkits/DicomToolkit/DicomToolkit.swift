//
//  DicomToolkit.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import SwiftUI

/// **DicomToolkit**
///
/// A Swift wrapper for handling DICOM image files using the **DCMTKWrapper**.
/// This struct provides methods for converting DICOM files into `UIImage`
/// and caching them for future use.
struct DicomToolkit {
    
    // MARK: - Properties
    
    /// **Cache Directory**
    ///
    /// The directory where converted DICOM images (BMP format) are temporarily stored.
    private let cacheDirectory: URL
    
    /// **DCMTK Wrapper**
    ///
    /// An instance of `DCMTKWrapper`, which interacts with the **DCMTK** library
    /// to convert DICOM files into standard image formats.
    private let dicomToolkit: DCMTKWrapper
    
    // MARK: - Conversion Methods
    
    /// **Convert a File Path to a `UIImage`**
    ///
    /// Attempts to read a file (BMP) from a given path and convert it into a `UIImage`.
    ///
    /// - Parameters:
    ///   - filePath: The full path to the image file.
    ///   - fileName: The file name (used if `path` is not provided).
    ///
    /// - Returns: A `UIImage` instance if successful.
    ///
    /// - Throws: `DcmVisionError.invalidImage` if the image cannot be loaded.
    private func imageFromFile(at filePath: String) throws -> UIImage {
        
        let imageData = try Data(contentsOf: URL(fileURLWithPath: filePath))
        
        // Convert raw data to UIImage
        guard let uiImage = UIImage(data: imageData) else {
            throw DcmVisionError.invalidImage
        }
        
        return uiImage
    }
    
    /// **Convert a File Path to a `UIImage`**
    ///
    /// Attempts to read a file (BMP) from a given path and convert it into a `UIImage`.
    ///
    /// - Parameters:
    ///   - fileName: The file name for checking the cache directory.
    ///
    /// - Returns: A `UIImage` instance if successful.
    ///
    /// - Throws: `DcmVisionError.invalidImage` if the image cannot be loaded.
    private func imageFromFile(named fileName: String) throws -> UIImage {
        
        let imageData = try Data(contentsOf: cacheDirectory.appendingPathComponent(
            fileName,
            conformingTo: .bmp
        ))
        
        // Convert raw data to UIImage
        guard let uiImage = UIImage(data: imageData) else {
            throw DcmVisionError.invalidImage
        }
        
        return uiImage
    }
    
    /// **Retrieve a `UIImage` from a DICOM File**
    ///
    /// - Attempts to load an image from cache.
    /// - If not found, converts the DICOM file to a BMP format using `DCMTKWrapper`
    ///   and then loads it into `UIImage`.
    ///
    /// - Parameter fileURL: The location of the DICOM file.
    ///
    /// - Returns: A `UIImage` representation of the DICOM file.
    /// - Throws:
    ///   - `DcmVisionError.fileNotFound` if the DICOM file cannot be found.
    ///   - `DcmVisionError.invalidFile` if the file cannot be converted.
    ///   - `DcmVisionError.invalidImage` if the image cannot be loaded.
    func imageFromFile(at fileURL: URL) throws -> UIImage {
        
        if let uiImage = try? imageFromFile(named: fileURL.lastPathComponent) {
            return uiImage
        }
        
        guard let imagePath = dicomToolkit.toBmp(
            from: fileURL.path(percentEncoded: false),
            named: fileURL.lastPathComponent
        ) else {
            throw DcmVisionError.invalidFile
        }
        
        return try imageFromFile(at: imagePath)
    }
    
    // MARK: - Validation Methods
        
    /// **Check if a File is a Valid DICOM**
    ///
    /// Uses `DCMTKWrapper` to validate whether the given file is a valid DICOM file.
    ///
    /// - Parameter fileURL: The location of the DICOM file.
    /// - Returns: `true` if the file is valid, `false` otherwise.
    func isValidDICOM(at fileURL: URL) -> Bool {
        
        dicomToolkit.isValidDICOM(
            fileURL.path(percentEncoded: false)
        )
    }
    
    // MARK: - Data Extraction Methods
    
    /// **Extract Raw Pixel Data from a DICOM File**
    ///
    /// Retrieves the raw pixel data from the DICOM file.
    ///
    /// - Parameter fileURL: The location of the DICOM file.
    /// - Returns: The pixel data as `Data`, or `nil` if extraction fails.
    func pixelDataFromFile(at fileURL: URL) throws -> Data {
        
        let filePath = fileURL.path(percentEncoded: false)
        
        guard let pixelData = dicomToolkit.pixelData(from: filePath) else {
            throw DcmVisionError.invalidFile
        }
        
        return pixelData
    }
    
    /// **Extract Metadata from a DICOM File**
    ///
    /// Extracts DICOM metadata such as **Patient Name, Patient ID, Study Date, Modality, etc.**
    ///
    /// - Parameter fileURL: The location of the DICOM file.
    /// - Returns: A dictionary containing the extracted metadata.
    func metadataFromFile(at fileURL: URL) throws -> [String: Any] {
        
        let filePath = fileURL.path(percentEncoded: false)
        let metadata = dicomToolkit.metadata(from: filePath) as? [String: Any]
        
        guard let metadata else {
            throw DcmVisionError.invalidFile
        }
        
        return metadata
    }
    
    /// **Initialize `DicomToolkit`**
    ///
    /// - Sets up the cache directory for storing temporary images.
    /// - Initializes `DCMTKWrapper` with the cache directory.
    init() throws {

        guard let cacheDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else {
            throw DcmVisionError.noCacheDirectory
        }
        
        guard let dicomToolkit = DCMTKWrapper(cacheDirectoryURL: cacheDirectory) else {
            throw DcmVisionError.dcmtkFailedInit
        }
        
        self.cacheDirectory = cacheDirectory
        self.dicomToolkit = dicomToolkit
    }
}
