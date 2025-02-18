//
//  DicomToolkit.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import SwiftUI

struct DicomToolkit {
    
    private let cacheDirectory: URL
    
    private let dicomToolkit: DCMTKWrapper
    
    private func uiImageFromFile(_ path: String? = nil, fileName: String) throws -> UIImage {
        
        let imageData: Data
        
        if let path {
            
            imageData = try .init(
                contentsOf: URL(fileURLWithPath: path)
            )
            
        } else {
            
            imageData = try .init(
                contentsOf: cacheDirectory.appendingPathComponent(
                    fileName,
                    conformingTo: .bmp
                )
            )
        }
        
        guard let uiImage = UIImage(data: imageData) else {
            throw DcmVisionError.invalidImage
        }
        
        return uiImage
    }
    
    func uiImageFromFile(withName fileName: String) throws -> UIImage {
        
        do {
            return try uiImageFromFile(fileName: fileName)
            
        } catch {
            
            guard let url = Bundle.main.url(
                forResource: fileName,
                withExtension: "dcm"
                
            ) else { throw DcmVisionError.fileNotFound }
            
            guard let imagePath = dicomToolkit.toPng(
                from: url.path(percentEncoded: false),
                named: fileName
                
            ) else { throw DcmVisionError.invalidFile }
            
            return try uiImageFromFile(imagePath, fileName: fileName)
        }
    }
    
    init() {
        cacheDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first!
        
        dicomToolkit = .init(cacheDirectoryURL: cacheDirectory)
    }
}
