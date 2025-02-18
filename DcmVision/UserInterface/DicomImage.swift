//
//  DicomImage.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import SwiftUI

struct DicomImage: View {
    
    private static let dcmtk: DicomToolkit = .init()
    
    let fileName: String
    
    @State private var dicomImage: Image? = nil
    
    var body: some View {
        
        Group {
            if let dicomImage = dicomImage {
                
                dicomImage
                    .resizable()
                    .scaledToFit()
                
            } else {
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .foregroundStyle(.yellow)
            }
        }
        .onAppear {
            self.dicomImage = try? Image(
                uiImage: Self.dcmtk.uiImageFromFile(
                    withName: fileName
                )
            )
        }
    }
}
