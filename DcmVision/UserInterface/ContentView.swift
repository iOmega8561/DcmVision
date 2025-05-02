//
//  ContentView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 13/03/25.
//

import Tools4SwiftUI

import UniformTypeIdentifiers

struct ContentView: View {
    
    @State private var fileImporterIsPresented: Bool = false
    
    @State private var selection: DicomDataSet? = nil
    
    @Environment(\.openWindow) private var openWindow
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        
        NavigationSplitView {
            
            List(appModel.dataSets) { dataSet in
                
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
        .asyncFileImporter(
            isPresented: $fileImporterIsPresented,
            allowedContentTypes: [.folder],
        ) { result in
            
            guard let directoryURL = result.first else {
                return
            }
            
            let dataSet = try DicomDataSet.createNew(
                originURL: directoryURL
            )
            
            appModel.dataSets.append(dataSet)
            selection = dataSet
        }
    }
}
