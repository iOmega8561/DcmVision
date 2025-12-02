//
//  Copyright (C) 2025  Giuseppe Rocco
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//  ----------------------------------------------------------------------
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
                            try appModel.removeDataSet(dataSet)
                            
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
                    .navigationTitle(selection.name)
                
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
            
            selection = try appModel.addDataSet(from: directoryURL)
        }
    }
}
