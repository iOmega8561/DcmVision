//
//  DicomFile.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 03/05/25.
//

import SwiftUI

/// A wrapper class for a DICOM file that provides lazy access to both the image and metadata.
///
/// - Note: `DicomFile` uses `lazy` properties to defer potentially expensive operations
///   (e.g., image parsing, metadata extraction) until they are first accessed.
/// - Important: `DicomFile` conforms to `Identifiable`, `Equatable`, and `Hashable` to support
///   use in SwiftUI views and collections.
final class DicomFile {
    
    static nonisolated func parseDirectory(at location: URL) throws -> [DicomFile] {
        let dcmtk = try DicomToolkit()
        
        return try FileManager.default.contentsOfDirectory(
            at: location,
            includingPropertiesForKeys: nil
        )
        .filter { dcmtk.isValidDICOM(at: $0) }
        .sorted { $0.lastPathComponent < $1.lastPathComponent }
        .map { DicomFile(url: $0) }
    }
    
    /// The file URL pointing to the DICOM file on disk.
    let url: URL
    
    /// Lazily-loaded result containing either the `UIImage` parsed from the DICOM file
    /// or an error if parsing fails.
    ///
    /// The image is loaded on first access using `DicomToolkit().imageFromFile(at:)`.
    /// The result is cached for subsequent accesses.
    lazy var uiImage: Result<UIImage, Error> = {
        do {
            return .success(
                try DicomToolkit().imageFromFile(at: url)
            )
        } catch {
            return .failure(error)
        }
    }()
    
    /// Lazily-loaded result containing either a dictionary of metadata parsed from the DICOM file,
    /// or an error if extraction fails.
    ///
    /// The metadata is loaded on first access using `DicomToolkit().metadataFromFile(at:)`.
    /// The result is cached for subsequent accesses.
    lazy var metadata: Result<DicomMetadata, Error> = {
        do {
            return .success(
                DicomMetadata(from: try DicomToolkit().metadataFromFile(at: url))
            )
        } catch {
            return .failure(error)
        }
    }()
    
    /// Initializes a new `DicomFile` with a file URL.
    /// - Parameter url: The file URL of the DICOM file.
    private init(url: URL) {
        self.url = url
    }
}

// MARK: - Identifiable

extension DicomFile: Identifiable {
    
    /// The unique identifier for the DICOM file, based on its file URL.
    var id: URL { self.url }
}

// MARK: - Equatable

extension DicomFile: Equatable {
    
    /// Compares two `DicomFile` instances for equality based on their URL.
    static func == (lhs: DicomFile, rhs: DicomFile) -> Bool {
        lhs.url == rhs.url
    }
}

// MARK: - Hashable

extension DicomFile: Hashable {
    
    /// Hashes the URL of the DICOM file into the given hasher.
    func hash(into hasher: inout Hasher) {
        url.hash(into: &hasher)
    }
}
