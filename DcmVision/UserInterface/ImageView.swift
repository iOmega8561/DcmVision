//
//  ImageView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import SwiftUI

struct ImageView: View {
        
    let fileURL: URL
    
    let showErrorDescription: Bool
    
    @State private var error: Error? = nil
    
    @State private var dicomImage: Image? = nil
    @State private var metadata: [String: Any] = [:]
    
    var body: some View {
        
        Group {
            if let dicomImage = dicomImage {
                
                dicomImage
                    .resizable()
                    .scaledToFit()
                    .overlay(alignment: .topLeading) {
                        
                        VStack(alignment: .leading) {
                            
                            ForEach(metadata.keys.sorted(), id: \.self) { key in
                                Text("\(key): \(metadata[key]!)")
                            }
                        }
                        .foregroundStyle(.white)
                        .padding()
                    }
                
            } else if let error {
                showErrorDescription ? ErrorView(error: error) : ErrorView()
                
            } else { ProgressView().scaleEffect(1.5) }
        }
        .task {
            do {
                try bootstrap()
                
            } catch { self.error = error }
        }
    }
    
    func bootstrap() throws {
        
        let dcmtk: DicomToolkit = try .init()
                                
        self.dicomImage = try Image(
            uiImage: dcmtk.imageFromFile(at: fileURL)
        )
                
        self.metadata = try dcmtk.metadataFromFile(at: fileURL)
    }
}
