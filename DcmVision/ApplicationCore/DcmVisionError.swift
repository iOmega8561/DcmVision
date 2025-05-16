//
//  DcmVisionError.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import Foundation

enum DcmVisionError: LocalizedError {
    case noCacheDirectory
    case dcmtkFailedInit
    case fileNotFound
    case invalidFile
    case invalidImage
    case failedToGenerateModel
    case conversionToUSDFailed
    case entityNotFound
    case entityAlreadyExists

    var errorDescription: String? {
        switch self {
        case .noCacheDirectory:      "Unable to locate or create the cache directory."
        case .dcmtkFailedInit:       "DCMTK failed to initialize properly."
        case .fileNotFound:          "The specified file could not be found."
        case .invalidFile:           "The file is not a valid DICOM file."
        case .invalidImage:          "The image data is invalid or unreadable."
        case .failedToGenerateModel: "Failed to generate the 3D model from the DICOM data."
        case .conversionToUSDFailed: "Conversion to USD format failed."
        case .entityNotFound:        "The requested entity was not found."
        case .entityAlreadyExists:   "The entity already exists in the context."
        }
    }
}
