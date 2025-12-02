//
//  Copyright (C) 2025  Giuseppe Rocco
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//  ----------------------------------------------------------------------
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
    
    /// Parses a directory and returns an array of `DicomFile` instances for each valid DICOM file found.
    ///
    /// This method scans the specified directory for files that are valid DICOM files,
    /// as determined by `DicomToolkit.isValidDICOM(at:)`. The resulting files are sorted
    /// lexicographically by their filename before being wrapped as `DicomFile` instances.
    ///
    /// - Parameter location: The URL of the directory to scan for DICOM files.
    /// - Returns: An array of `DicomFile` objects representing the valid DICOM files in the directory.
    /// - Throws: An error if the directory contents cannot be read or if `DicomToolkit` initialization fails.
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
    init(url: URL) {
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

// MARK: - Codable

extension DicomFile: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(url)
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let url = try container.decode(URL.self)
        
        self.init(url: url)
    }
}
