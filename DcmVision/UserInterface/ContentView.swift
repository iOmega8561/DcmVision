//
//  ContentView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 13/03/25.
//

import SwiftUI

import UniformTypeIdentifiers

struct ContentView: View {
    
    @State private var fileImporterIsPresented: Bool = false
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        
        VStack {
    
            Text("Welcome to DcmVision")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            Button("Pick a DICOM directory") {
                fileImporterIsPresented = true
            }
            
        }
        .fileImporter(
            isPresented: $fileImporterIsPresented,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            
            guard let urls = try? result.get() else {
                return
            }
            
            if let directoryURL = urls.first {
                
                openWindow(id: "dicom", value: directoryURL)
            }
        }
    }
}
