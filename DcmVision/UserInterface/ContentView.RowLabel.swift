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
