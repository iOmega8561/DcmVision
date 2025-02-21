//
//  InsightToolkit.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 18/02/25.
//

import Foundation

/// **InsightToolkit**
///
/// A Swift wrapper around the **ITKWrapper**, enabling **DICOM image processing**
/// via the ITK (Insight Toolkit) library.
///
/// This struct provides a method to **load DICOM files** and manages a cache directory
/// for temporary file storage.
struct InsightToolkit {
    
    /// **Cache Directory**
    ///
    /// The directory where ITK stores temporary DICOM processing data.
    private let cacheDirectory: URL
    
    /// **ITK Wrapper Instance**
    ///
    /// An instance of `ITKWrapper` to interact with the ITK library.
    private let insightToolkit: ITKWrapper
    
    /// **Load a DICOM File**
    ///
    /// Attempts to load a DICOM file from the application bundle to
    /// check if the DICOM format is valid using the **ITK library**.
    ///
    /// - Parameter fileName: The name of the DICOM file (without extension).
    ///
    /// - Throws:
    ///   - `DcmVisionError.fileNotFound` if the DICOM file cannot be located in the app bundle.
    func loadDICOM(withName fileName: String) throws {
        
        // Locate the DICOM file in the app bundle
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "dcm"
        ) else {
            throw DcmVisionError.fileNotFound
        }
        
        // Pass the file path to ITK for processing
        insightToolkit.isValidDICOM(
            url.path(percentEncoded: false)
        )
    }
    
    /// **Initialize InsightToolkit**
    ///
    /// - Sets up a cache directory for storing temporary DICOM processing files.
    /// - Initializes an `ITKWrapper` instance with the cache directory.
    init() throws {
        
        // Retrieve the system cache directory
        guard let cacheDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else {
            throw DcmVisionError.noCacheDirectory
        }
        
        self.cacheDirectory = cacheDirectory
        
        // Initialize the ITK wrapper with the cache directory
        self.insightToolkit = ITKWrapper(cacheDirectoryURL: cacheDirectory)
    }
}

