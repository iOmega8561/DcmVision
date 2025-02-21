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
    
    /// **Cache Directory**
    ///
    /// The directory where converted DICOM images (BMP format) are temporarily stored.
    private let cacheDirectory: URL
    
    /// **DCMTK Wrapper**
    ///
    /// An instance of `DCMTKWrapper`, which interacts with the **DCMTK** library
    /// to convert DICOM files into standard image formats.
    private let dicomToolkit: DCMTKWrapper
    
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
    private func uiImageFromFile(_ path: String? = nil, fileName: String) throws -> UIImage {
        
        let imageData: Data
        
        if let path {
            // Load image from a specific file path
            imageData = try Data(contentsOf: URL(fileURLWithPath: path))
        } else {
            // Load image from cache directory
            imageData = try Data(
                contentsOf: cacheDirectory.appendingPathComponent(
                    fileName,
                    conformingTo: .bmp
                )
            )
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
    ///
    /// - Throws:
    ///   - `DcmVisionError.fileNotFound` if the DICOM file cannot be found.
    ///   - `DcmVisionError.invalidFile` if the file cannot be converted.
    ///   - `DcmVisionError.invalidImage` if the image cannot be loaded.
    func uiImageFromFile(withName fileName: String) throws -> UIImage {
        
        do {
            // Try to load image from cache
            return try uiImageFromFile(fileName: fileName)
            
        } catch {
            
            // Locate the DICOM file in the app bundle
            guard let url = Bundle.main.url(
                forResource: fileName,
                withExtension: "dcm"
            ) else {
                throw DcmVisionError.fileNotFound
            }
            
            // Convert DICOM to BMP using DCMTKWrapper
            guard let imagePath = dicomToolkit.toBmp(
                from: url.path(percentEncoded: false),
                named: fileName
            ) else {
                throw DcmVisionError.invalidFile
            }
            
            // Load the converted BMP image
            return try uiImageFromFile(imagePath, fileName: fileName)
        }
    }
    
    /// **Initialize `DicomToolkit`**
    ///
    /// - Sets up the cache directory for storing temporary images.
    /// - Initializes `DCMTKWrapper` with the cache directory.
    init() {
        // Get the user's cache directory
        cacheDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first!
        
        // Initialize the DCMTK wrapper
        dicomToolkit = DCMTKWrapper(cacheDirectoryURL: cacheDirectory)
    }
}
