//
//  GridView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 13/03/25.
//

import SwiftUI

struct GridView: View {
    
    let dicomURLs: [URL]
    
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: gridItemLayout, spacing: 10) {
                
                ForEach(dicomURLs, id: \.self.absoluteString) { url in
                    
                    NavigationLink {
                        
                        ImageView(fileURL: url, showErrorDescription: true)
                            .navigationTitle(url.lastPathComponent)
                    } label: {
                        
                        ImageView(fileURL: url, showErrorDescription: false)
                            .frame(minWidth: 150, minHeight: 150)
                    }
                    .id(url)
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
