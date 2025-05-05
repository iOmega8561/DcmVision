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
            
            List(appModel.dataSets, selection: $selection) { dataSet in
                
                RowLabel(dataSet: dataSet)
                    .tag(dataSet)
                    .contextMenu {
                        AsyncButton("Delete", systemImage: "trash", role: .destructive) {
                            try await appModel.removeDataSet(dataSet)
                            
                            if selection == dataSet {
                                selection = nil
                            }
                        }
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
                GridView(dataSet: selection)
                    .id(selection.id)
                    .navigationTitle({
                        if case .success(let metadata) = selection.files.first?.metadata,
                           let patientName = metadata.patientName,
                           let studyProcedure = metadata.studyProcedure {
                            return patientName + " - " + studyProcedure
                            
                        } else { return selection.id.uuidString }
                    }())
                
            } else {
                
                Text("Welcome to DcmVision")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                
                Text("Choose a folder containing DICOM files to begin.")
                    .foregroundColor(.secondary)
                
                Text("Once loaded, select a scan from the list to view its image, metadata, and 3D reconstruction.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
        }
        .asyncFileImporter(
            isPresented: $fileImporterIsPresented,
            allowedContentTypes: [.folder],
        ) {
            guard let directoryURL = $0.first else {
                return
            }
            selection = try await appModel.addDataSet(
                from: directoryURL
            )
        }
    }
}
