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
    
    @State private var dataSets: [DicomDataSet] = []
    @State private var selection: DicomDataSet? = nil
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        
        NavigationSplitView {
            
            List(dataSets) { dataSet in
                
                Button(dataSet.name) {
                    selection = dataSet
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    
                    Button("Pick a DICOM directory", systemImage: "plus") {
                        fileImporterIsPresented = true
                    }
                }
            }
            
        } detail: {
            
            if let selection {
                GridContainerView(dataSet: selection)
                    .navigationTitle(selection.name)
                    .id(selection.id)
                
            } else {
                
                Text("Welcome to DcmVision")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
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
                
                dataSets.append(dataSet)
                selection = dataSet
                
            } catch { self.error = error }
        }
    }
}
