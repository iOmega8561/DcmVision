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
