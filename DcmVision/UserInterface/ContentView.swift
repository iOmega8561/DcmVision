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
    
    @State private var error: Error? = nil
    
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
        
        .alert("Error", isPresented: .constant(error != nil)) {
            Button("OK") {
                error = nil
            }
            
        } message: {
            Text(error?.localizedDescription ?? "Error")
        }
        
        .fileImporter(
            isPresented: $fileImporterIsPresented,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            
            guard let urls = try? result.get(),
                  let directoryURL = urls.first else { return }
           
            do {
                let dataSet = try DicomDataSet.createNew(
                    originURL: directoryURL
                )
                
                openWindow(id: "dicom", value: dataSet)
                
            } catch { self.error = error }
        }
    }
}
