//
//  DicomDataSet.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 24/03/25.
//

/// A representation of a locally cached DICOM dataset.
///
/// `DicomDataSet` is used to encapsulate metadata and file references for a
/// DICOM directory copied into the app's cache. It conforms to `Identifiable`,
/// `Hashable`, and `Codable`, making it easy to store, compare, and use in SwiftUI views.
struct DicomDataSet: Identifiable, Hashable, Codable {
    
    /// Creates a new `DicomDataSet` by copying the contents of a source directory to the cache.
    ///
    /// This function:
    /// - Generates a new UUID for the dataset.
    /// - Copies the contents of the provided `originURL` directory to a new folder in the cache.
    /// - Enumerates the DICOM files in the copied directory to calculate `sliceCount`.
    ///
    /// Security-scoped access is automatically managed for the origin URL.
    ///
    /// - Parameter originURL: The URL of the original directory containing DICOM files.
    /// - Throws: An error if copying the directory or reading its contents fails.
    /// - Returns: A new `DicomDataSet` instance.
    static func createNew(originURL: URL) throws -> DicomDataSet {
        let newUUID: UUID = .init()
        let destinationURL: URL = .cacheDirectory.appendingPathComponent(newUUID.uuidString)
                
        try originURL.whileAccessingSecurityScopedResource {
            try FileManager.default.copyItem(at: originURL, to: destinationURL)
        }
        
        return .init(id: newUUID, name: originURL.lastPathComponent)
    }
    
    /// Unique identifier for the dataset.
    let id: UUID
    
    /// A human-readable name for the dataset, typically the folder name of the original source.
    let name: String
    
    /// The full URL to the cached location of the dataset.
    var url: URL {
        .cacheDirectory.appendingPathComponent(id.uuidString)
    }
    
    /// Initializes a new `DicomDataSet` with its core properties.
    ///
    /// This initializer is private to enforce creation via `createNew`.
    ///
    /// - Parameters:
    ///   - id: The UUID assigned to this dataset.
    ///   - name: The name of the dataset.
    private init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
