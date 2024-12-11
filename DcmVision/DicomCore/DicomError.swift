//
//  DicomError.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import Foundation

enum DicomError: Error {
    case fileNotFound
    case invalidFile
    case invalidImage
}
