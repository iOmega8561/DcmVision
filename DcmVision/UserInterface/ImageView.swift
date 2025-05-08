//
//  ImageView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import SwiftUI

struct ImageView: View {
    
    let dicomFile: DicomFile
    let isDetail: Bool
    
    let metadataIsShown: Bool
    
    var body: some View {
        
        switch(dicomFile.uiImage, dicomFile.metadata) {
        case (.success(let uiImage), .failure(_)):
            
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .saturation(1.5)
                .contrast(1.2)
                .brightness(0.05)
            
        case (.success(let uiImage), .success(let metadata)):
            
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .saturation(1.5)
                .contrast(1.2)
                .brightness(0.05)
                .overlay {
                    if isDetail && metadataIsShown {
                        MetadataOverlay(dicomMetadata: metadata)
                    }
                }
            
        case (.failure(let error), _):
            
            isDetail ? ErrorView(error: error) : ErrorView()
        }
    }
}
