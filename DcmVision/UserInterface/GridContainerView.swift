//
//  GridContainerView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

import SwiftUI

struct GridContainerView: View {
    
    let dataSet: DicomDataSet
    
    @State private var dicomURLs: [URL]? = nil
    @State private var error: String? = nil
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        
        if let dicomURLs {
            
            GridView(dicomURLs: dicomURLs)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        
                        Button("Show 3D visualization") {
                            openWindow(id: "volume", value: dataSet)
                        }
                    }
                }
            
        } else if let error {
            ErrorView(error: error)
            
        } else {
            
            LoadingView()
                .onAppear {
                    
                    Task.detached(priority: .utility) {
                        do {
                            let sortedSlices = try dataSet.sortedSlices()
                            
                            await MainActor.run { self.dicomURLs = sortedSlices }
                            
                        } catch { await MainActor.run { self.error = error.localizedDescription } }
                    }
                }
        }
    }
}
