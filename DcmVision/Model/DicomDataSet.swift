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
struct DicomDataSet: Identifiable {
    
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
    static nonisolated func createNew(originURL: URL) throws -> DicomDataSet {
        let newUUID: UUID = .init()
        let destinationURL: URL = .cacheDirectory.appendingPathComponent(newUUID.uuidString)
                
        try originURL.whileAccessingSecurityScopedResource {
            try FileManager.default.copyItem(at: originURL, to: destinationURL)
        }
        
        return .init(id: newUUID, files: try DicomFile.parseDirectory(at: destinationURL))
    }
    
    /// Unique identifier for the dataset.
    let id: UUID
    
    /// A list keeping references to the DICOM Files part of this Data Set
    let files: [DicomFile]
    
    /// The full URL to the cached location of the dataset.
    var url: URL {
        .cacheDirectory.appendingPathComponent(id.uuidString)
    }
    
    /// Generates a 3D isosurface representation from the DICOM dataset using a given HU threshold.
    ///
    /// This method utilizes `VisualizationToolkit` to perform the surface generation based on intensity values.
    ///
    /// - Parameter huThreshold: The threshold in Hounsfield units to construct the surface.
    /// - Throws: An error if surface generation fails.
    /// - Returns: A URL to the generated surface model file.
    nonisolated func isoSurface(huThreshold: Double) throws -> URL {
        
        let visualizationToolkit: VisualizationToolkit = .init()
        
        return try visualizationToolkit.generateDICOM(
            fromDirectory: self.url,
            withName: self.id.uuidString,
            threshold: huThreshold
        )
    }
    
    /// Initializes a new `DicomDataSet` with its core properties.
    ///
    /// This initializer is private to enforce creation via `createNew`.
    ///
    /// - Parameters:
    ///   - id: The UUID assigned to this dataset.
    ///   - name: The name of the dataset.
    init(id: UUID, files: [DicomFile]) {
        self.id = id
        self.files = files
    }
}

// MARK: - Equatable

extension DicomDataSet: Equatable {
    
    /// Compares two `DicomFile` instances for equality based on their URL.
    static func == (lhs: DicomDataSet, rhs: DicomDataSet) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension DicomDataSet: Hashable {
    
    /// Hashes the URL of the DICOM file into the given hasher.
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
