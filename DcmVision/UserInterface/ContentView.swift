//
//  ContentView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

import SwiftUI

struct ContentView: View {
    
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var fileName: (Int) -> String = { integer in
        return "1-\(String(format: "%02d", integer))"
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                LazyVGrid(columns: gridItemLayout, spacing: 10) {
                    
                    ForEach(1..<95) { integer in
                        
                        NavigationLink {
                            
                            DicomImage(fileName: fileName(integer))
                                .navigationTitle("\(fileName(integer)).dcm")
                            
                        } label: {
                            
                            DicomImage(fileName: fileName(integer))
                                .frame(
                                    minWidth: 150,
                                    maxWidth: 300,
                                    minHeight: 150,
                                    maxHeight: 300
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("DICOM Data Set")
        }
    }
}
