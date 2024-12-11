//
//  DicomView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import SwiftUI

struct DicomView: View {
    
    private enum DicomError: Error {
        case fileNotFound
        case invalidFile
        case invalidImage
    }
    
    let fileName: String
    
    @State private var dicomImage: Image? = nil
    @State private var failed: Bool = false
    
    var body: some View {
        
        Group {
            if let dicomImage = dicomImage {
                
                dicomImage
                    .resizable()
                    .scaledToFit()
                
            } else if !failed {
                
                ProgressView()
                
            } else {
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .foregroundStyle(.yellow)
            }
        }
        .onAppear {
            do {
                self.dicomImage = try Image(
                    uiImage: loadDcmImage()
                )
                
            } catch { failed = true }
        }
    }
    
    private func loadExistingDcmImage(path: String? = nil) throws -> UIImage {
        
        let imageData: Data
        
        if let path {
            imageData = try .init(contentsOf: URL(fileURLWithPath: path))
            
        } else {
            imageData = try .init(
                contentsOf: URL(
                    fileURLWithPath: NSTemporaryDirectory() + fileName + ".bmp"
                )
            )
        }
        
        guard let uiImage = UIImage(data: imageData) else {
            throw DicomError.invalidImage
        }
        
        return uiImage
    }
    
    private func loadDcmImage() throws -> UIImage {
        
        do {
            return try loadExistingDcmImage()
            
        } catch {
            
            guard let url = Bundle.main.url(
                forResource: fileName,
                withExtension: "dcm"
                
            ) else { throw DicomError.fileNotFound }
            
            guard let imagePath = DcmDecoder().toPng(
                from: url.path(percentEncoded: false),
                named: fileName
                
            ) else { throw DicomError.invalidFile }
            
            return try loadExistingDcmImage(path: imagePath)
        }
    }
}
