//
//  DicomImage.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import SwiftUI

struct DicomImage: View {
        
    let fileName: String
    
    @State private var dicomImage: Image? = nil
    @State private var isValidDICOM: Bool = false
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
                    .overlay(alignment: .bottomLeading) {
                        if isValidDICOM {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 50, maxHeight: 50)
                                .foregroundStyle(.green)
                                .padding()
                        }
                    }
                
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
                let dcmtk: DicomToolkit = try .init()
                
                self.isValidDICOM = try dcmtk.isValidDICOM(named: fileName)
                
                self.dicomImage = try Image(
                    uiImage: dcmtk.imageFromFile(named: fileName)
                )
                
                self.metadata = try dcmtk.metadataFromFile(named: fileName)
                
            } catch { print(error.localizedDescription) }
        }
    }
}
