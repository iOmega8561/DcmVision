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
//  ContentView.RowLabel.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 03/05/25.
//

import SwiftUI

extension ContentView {
    
    struct RowLabel: View {
        
        let dataSet: DicomDataSet
        
        var body: some View {
            
            switch dataSet.files.first?.metadata {
            case .success(let metadata):
                
                VStack(alignment: .leading) {
                    
                    HStack(alignment: .center) {
                        
                        VStack(alignment: .leading) {
                            
                            if let patientName = metadata.patientName {
                                Text(patientName)
                                    .font(.headline)
                            }
                            
                            if let studyDate = metadata.studyTimeDate {
                                
                                Text(studyDate.formatted())
                                    .font(.caption)
                                    .padding(.bottom)
                            }
                        }
                        
                        Spacer()
                        
                        Text(dataSet.files.count.description)
                            .font(.largeTitle)
                    }
                    
                    if let studyArea = metadata.studyArea {
                        Text(studyArea)
                    }
                    
                    if let studyProcedure = metadata.studyProcedure {
                        
                        Text(studyProcedure)
                            .font(.caption)
                    }
                }
                .lineLimit(1)
                
            case .failure(let error): ErrorView(error: error)
            default: ErrorView()
            }
        }
    }
}
