//
//  GridStackView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

import SwiftUI

struct GridStackView: View {
    
    let dataSet: DicomDataSet
    
    @State private var dicomURLs: [URL]? = nil
    @State private var error: String? = nil
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        
        NavigationStack {
            
            if let dicomURLs {
                
                GridView(dicomURLs: dicomURLs)
                    .navigationTitle("DICOM Data Set")
                    .toolbar {
                        
                        ToolbarItem(placement: .automatic) {
                            
                            Button("Show 3D visualization") {
                                openWindow(id: "volume", value: dataSet)
                            }
                        }
                    }
                
            } else if let error {
                ErrorView(error: error)
                
            } else { LoadingView() }
        }
        .task {
            do {
                dicomURLs = try loadFileURLs()
                
            } catch { self.error = error.localizedDescription }
        }
    }
    
    func loadFileURLs() throws -> [URL] {
        
        let fileURLs = try FileManager.default.contentsOfDirectory(
            at: dataSet.url,
            includingPropertiesForKeys: nil
        )
        
        let dcmtk = try DicomToolkit()
        
        let filteredURLs = fileURLs.filter { dcmtk.isValidDICOM(at: $0) }
        
        return filteredURLs.sorted { $0.lastPathComponent < $1.lastPathComponent }        
    }
}
