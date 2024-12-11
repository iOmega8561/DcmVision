//
//  ContentView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

import SwiftUI
import RealityKit

import SwiftUI

struct ContentView: View {
    
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                LazyVGrid(columns: gridItemLayout, spacing: 10) {
                    
                    ForEach(1..<95) { integer in
                        
                        NavigationLink(destination: DicomView(
                            fileName: "1-\(String(format: "%02d", integer))"
                        )) {
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black)
                                
                                DicomView(
                                    fileName: "1-\(String(format: "%02d", integer))"
                                )
                            }
                            .frame(width: 300, height: 300)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(minWidth: 950, minHeight: 600)
            }
        }
    }
}
