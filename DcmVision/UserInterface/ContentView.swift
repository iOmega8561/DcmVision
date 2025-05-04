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
                        } else { return "" }
                    }())
                
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
