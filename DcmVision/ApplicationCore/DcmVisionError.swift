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
