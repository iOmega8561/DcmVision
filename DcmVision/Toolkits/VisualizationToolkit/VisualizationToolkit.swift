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
    
    /// The underlying VTKWrapper instance that provides access to VTK functionalities.
    private let vtkWrapper: VTKWrapper = .init(cacheDirectoryURL: .cacheDirectory)
    
    // MARK: - Private Methods
    
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
    
    /// Retrieves a USD file from the cache and verifies its validity.
    ///
    /// This method attempts to read a USD file from the cache directory, checking whether
    /// it is a valid binary USD (`.usdc` or `.usd`) file by inspecting its header. If the file does
    /// not exist or fails validation, an error is thrown.
    ///
    /// - Parameter fileName: The name of the USD file to retrieve.
    /// - Throws:
    ///   - `DcmVisionError.invalidFile` if the file exists but is not a valid binary USD file.
    ///   - Any errors encountered while accessing the file system (e.g., file not found).
    /// - Returns: A `URL` pointing to the validated USD file within the cache directory.
    private func getNamedUSDFromCache(_ fileName: String) throws -> URL {
                
        let fileHandle = try FileHandle(
            forReadingFrom: .cacheDirectory.appendingPathComponent(fileName, conformingTo: .usd)
        )
        
        let headerData = fileHandle.readData(ofLength: "PXR-USDC".count)
        fileHandle.closeFile()
        
        guard let headerString = String(data: headerData, encoding: .utf8),
              headerString.contains("PXR-USDC") else {
            throw DcmVisionError.invalidFile
        }
        
        return .cacheDirectory.appendingPathComponent(fileName, conformingTo: .usd)
    }
    
    // MARK: - Public Methods
    
    /// Generates a 3D model from a DICOM dataset and converts it to USD.
    ///
    /// This method first calls the private `getNamedUSDFromCache(:_)` to check if the requested model
    /// has already been cached. If not, it uses the VTKWrapper to read a directory of DICOM files,
    /// apply a Marching Cubes isosurface extraction using the specified threshold, and export the resulting
    /// model as an OBJ file. The OBJ file is then loaded into a ModelIO asset and exported as a USD file.
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
        
        if let cachedURL = try? getNamedUSDFromCache(fileName) {
            return cachedURL
        }
        
        guard let vtkOutput = vtkWrapper.generate3DModel(
            fromDICOMDirectory: directoryURL.path(percentEncoded: false),
            fileName: fileName,
            threshold: threshold
        ) else {
            throw DcmVisionError.failedToGenerateModel
        }
        
        return try convertToUSD(vtkOutput)
    }
}
