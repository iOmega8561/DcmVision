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
    
    // MARK: - Helper Methods
    
    /// **Get a File URL from the Main Bundle**
    ///
    /// - Parameter name: The file name (without extension).
    /// - Throws: `DcmVisionError.fileNotFound` if the file does not exist.
    /// - Returns: The full file URL.
    private func getFileURL(_ name: String) throws -> URL {
        
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: "dcm"
        ) else {
            throw DcmVisionError.fileNotFound
        }
        
        return url
    }
    
    // MARK: - Conversion Methods
    
    /// **Convert a File Path to a `UIImage`**
    ///
    /// Attempts to read a file (BMP) from a given path and convert it into a `UIImage`.
    ///
    /// - Parameters:
    ///   - path: The full path to the image file (optional).
    ///   - fileName: The file name (used if `path` is not provided).
    ///
    /// - Returns: A `UIImage` instance if successful.
    ///
    /// - Throws: `DcmVisionError.invalidImage` if the image cannot be loaded.
    private func imageFromFile(_ path: String? = nil, fileName: String) throws -> UIImage {
        
        let imageData: Data
        
        if let path {
            imageData = try Data(contentsOf: URL(fileURLWithPath: path))
            
        } else {
        
            imageData = try Data(contentsOf: cacheDirectory.appendingPathComponent(
                fileName,
                conformingTo: .bmp
            ))
        }
        
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
    /// - Parameter fileName: The name of the DICOM file (without extension).
    ///
    /// - Returns: A `UIImage` representation of the DICOM file.
    /// - Throws:
    ///   - `DcmVisionError.fileNotFound` if the DICOM file cannot be found.
    ///   - `DcmVisionError.invalidFile` if the file cannot be converted.
    ///   - `DcmVisionError.invalidImage` if the image cannot be loaded.
    func imageFromFile(named fileName: String) throws -> UIImage {
        
        if let uiImage = try? imageFromFile(fileName: fileName) {
            return uiImage
        }
        
        guard let imagePath = dicomToolkit.toBmp(
            from: try getFileURL(fileName).path(percentEncoded: false),
            named: fileName
        ) else {
            throw DcmVisionError.invalidFile
        }
        
        return try imageFromFile(imagePath, fileName: fileName)
    }
    
    // MARK: - Validation Methods
        
    /// **Check if a File is a Valid DICOM**
    ///
    /// Uses `DCMTKWrapper` to validate whether the given file is a valid DICOM file.
    ///
    /// - Parameter fileName: The name of the DICOM file (without extension).
    /// - Returns: `true` if the file is valid, `false` otherwise.
    func isValidDICOM(named fileName: String) throws -> Bool {
        
        dicomToolkit.isValidDICOM(
            try getFileURL(fileName).path(percentEncoded: false)
        )
    }
    
    // MARK: - Data Extraction Methods
    
    /// **Extract Raw Pixel Data from a DICOM File**
    ///
    /// Retrieves the raw pixel data from the DICOM file.
    ///
    /// - Parameter fileName: The name of the DICOM file (without extension).
    /// - Returns: The pixel data as `Data`, or `nil` if extraction fails.
    func pixelDataFromFile(named fileName: String) throws -> Data {
        
        let filePath = try getFileURL(fileName).path(percentEncoded: false)
        
        guard let pixelData = dicomToolkit.pixelData(from: filePath) else {
            throw DcmVisionError.invalidFile
        }
        
        return pixelData
    }
    
    /// **Extract Metadata from a DICOM File**
    ///
    /// Extracts DICOM metadata such as **Patient Name, Patient ID, Study Date, Modality, etc.**
    ///
    /// - Parameter fileName: The name of the DICOM file (without extension).
    /// - Returns: A dictionary containing the extracted metadata.
    func metadataFromFile(named fileName: String) throws -> [String: Any] {
        
        let filePath = try getFileURL(fileName).path(percentEncoded: false)
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
