//
//  VisualizationToolkit.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 03/03/25.
//

import Foundation

import ModelIO

/// A Swift wrapper around the VTKWrapper, providing high-level 3D model generation from
/// DICOM datasets (or via simple geometric primitives) and conversion to USD format.
struct VisualizationToolkit {
    
    // MARK: - Properties
    
    /// The cache directory where temporary files are stored.
    private let cacheDirectory: URL
    
    /// The underlying VTKWrapper instance that provides access to VTK functionalities.
    private let vtkWrapper: VTKWrapper
    
    /// Converts an OBJ file to USD format.
    ///
    /// This method creates a ModelIO asset from the OBJ file located at the specified file path, then exports that
    /// asset to a new file with a "usd" extension in the same directory.
    /// If the export process fails, the method throws a DcmVisionError.conversionToUSDFailed error.
    ///
    /// - Parameter objFilePath: The full file system path to the OBJ file to be converted.
    /// - Throws: DcmVisionError.conversionToUSDFailed if the asset cannot be exported to USD.
    /// - Returns: The file URL of the generated USD file.
    private func convertToUSD(_ objFilePath: String) throws -> URL {
        
        let objFileURL: URL = .init(fileURLWithPath: objFilePath)
        
        let mdlAsset: MDLAsset = .init(url: objFileURL)
        
        let destinationURL = objFileURL
            .deletingPathExtension()
            .appendingPathExtension("usd")
        
        do {
            try mdlAsset.export(to: destinationURL)
            
        } catch { throw DcmVisionError.conversionToUSDFailed }
        
        return destinationURL
    }
    
    // MARK: - Public Methods
    
    /// Generates a 3D model from a DICOM dataset and converts it to USD.
    ///
    /// This method uses the VTKWrapper to read a directory of DICOM files, apply a Marching Cubes
    /// isosurface extraction using the specified threshold, and export the resulting model as an OBJ file.
    /// The OBJ file is then loaded into a ModelIO asset and exported as a USD file.
    ///
    /// - Parameters:
    ///   - directoryURL: The file URL to the directory containing the DICOM files.
    ///   - fileName: The base file name (without extension) to use for the output model.
    ///   - threshold: The isosurface threshold value (e.g., in Hounsfield units for CT data).
    /// - Returns: The file URL of the generated USD model.
    /// - Throws: `DcmVisionError.failedToGenerateModel` if VTKWrapper fails to generate the OBJ;
    ///           `DcmVisionError.conversionToUSDFailed` if the conversion to USD fails.
    func generateDICOM(
        fromDirectory directoryURL: URL,
        withName fileName: String,
        threshold: Double
    ) throws -> URL {
        
        guard let vtkOutput = vtkWrapper.generate3DModel(fromDICOMDirectory: directoryURL.path(percentEncoded: false),
            fileName: fileName,
            threshold: threshold
        ) else {
            throw DcmVisionError.failedToGenerateModel
        }
        
        return try convertToUSD(vtkOutput)
    }
    
    /// Generates a simple 3D sphere model and converts it to USD.
    ///
    /// This method uses the VTKWrapper to generate a sphere as an OBJ file and then converts
    /// it to a USD file using ModelIO.
    ///
    /// - Parameter fileName: The base file name (without extension) for the output model.
    /// - Returns: The file URL of the generated USD model.
    /// - Throws: `DcmVisionError.noCacheDirectory` if no cache directory is available;
    ///           `DcmVisionError.conversionToUSDFailed` if the conversion to USD fails.
    func generateSphere(withName fileName: String) throws -> URL {
        
        guard let vtkOutput = vtkWrapper.generateSphereAndExport(fileName) else {
            throw DcmVisionError.failedToGenerateModel
        }
        
        return try convertToUSD(vtkOutput)
    }
    
    // MARK: - Initialization
    
    /// Initializes a new instance of VisualizationToolkit.
    ///
    /// This initializer retrieves a cache directory from the user's caches folder and
    /// instantiates the VTKWrapper with that directory.
    ///
    /// - Throws: `DcmVisionError.noCacheDirectory` if no cache directory can be found.
    init() throws {
        
        // Retrieve the system cache directory
        guard let cacheDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else {
            throw DcmVisionError.noCacheDirectory
        }
        
        self.cacheDirectory = cacheDirectory
        
        // Initialize the VTKWrapper with the cache directory.
        self.vtkWrapper = VTKWrapper(cacheDirectoryURL: cacheDirectory)
    }
}
