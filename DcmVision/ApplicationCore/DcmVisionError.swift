//
//  DcmVisionError.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import Foundation

enum DcmVisionError: Error {
    case noCacheDirectory
    case dcmtkFailedInit
    case fileNotFound
    case invalidFile
    case invalidImage
    case failedToGenerateModel
    case conversionToUSDFailed
    case entityNotFound
    case entityAlreadyExists
}
