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
//  ImageView.MetadataOverlay.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 11/12/24.
//

import SwiftUI

extension ImageView {
    
    struct MetadataOverlay: View {
        
        let dicomMetadata: DicomMetadata
        
        var body: some View {
            
            Color.clear
                .overlay(alignment: .topLeading) {
                    topLeftOverlay(dicomMetadata)
                }
                .overlay(alignment: .topTrailing) {
                    topRightOverlay(dicomMetadata)
                }
                .overlay(alignment: .bottomLeading) {
                    bottomLeftOverlay(dicomMetadata)
                }
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.red)
        }
        
        // MARK: - Overlays
        
        func topLeftOverlay(_ metadata: DicomMetadata) -> some View {
            VStack(alignment: .leading, spacing: 2) {
                
                if let manufacturer = metadata.manufacturer {
                    Text("\(manufacturer)")
                }
                
                if let seriesNumber = metadata.seriesNumber {
                    Text("Se: \(seriesNumber)")
                }
                
                if let instanceNumber = metadata.instanceNumber,
                   let imagesInAcquisition = metadata.imagesInAcquisition {
                    Text("Im: \(instanceNumber)/\(imagesInAcquisition)")
                    
                } else if let instanceNumber = metadata.instanceNumber {
                    Text("Im: \(instanceNumber)")
                }
            }
            .padding([.top, .leading], 8)
        }
        
        func topRightOverlay(_ metadata: DicomMetadata) -> some View {
            VStack(alignment: .trailing, spacing: 2) {
                
                if let patientID = metadata.patientID {
                    Text("\(patientID)")
                }
                
                if let patientName = metadata.patientName {
                    Text("\(patientName)")
                }
                
                if let patientSex = metadata.patientSex,
                   let patientAge = metadata.patientAge {
                    Text("\(patientSex) \(patientAge)")
                }
                
                if let studyProcedure = metadata.studyProcedure,
                   let convolutionKernel = metadata.convolutionKernel {
                    Text("\(studyProcedure)  \(convolutionKernel)")
                }
            }
            .padding([.top, .trailing], 8)
        }
        
        func bottomLeftOverlay(_ metadata: DicomMetadata) -> some View {
            VStack(alignment: .leading, spacing: 2) {
                
                if let timeDate = metadata.studyTimeDate {
                    Text(timeDate.formatted(date: .abbreviated, time: .omitted))
                    Text(timeDate.formatted(date: .omitted, time: .complete))
                }
            }
            .padding([.bottom, .leading], 8)
        }
    }
}
