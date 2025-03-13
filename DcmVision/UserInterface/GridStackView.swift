//
//  GridStackView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

import SwiftUI

struct GridStackView: View {
    
    let directoryURL: URL
    
    @State private var dicomURLs: [URL]? = nil
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        
        NavigationStack {
            
            if let dicomURLs {
                
                GridView(dicomURLs: dicomURLs)
                    .navigationTitle("DICOM Data Set")
                    .toolbar {
                        
                        ToolbarItem(placement: .automatic) {
                            
                            Button("Show 3D visualization") {
                                openWindow(id: "volume", value: directoryURL)
                            }
                        }
                    }
        
            } else { LoadingView() }
        }
        .task {
            
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(
                    at: directoryURL,
                    includingPropertiesForKeys: nil
                )
                
                let dcmtk = try DicomToolkit()
                
                dicomURLs = fileURLs.filter {
                    dcmtk.isValidDICOM(at: $0)
                }
                
            } catch { print("❌ Error reading directory: \(error.localizedDescription)") }
        }
    }
}
