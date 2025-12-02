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
//  GridView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 13/03/25.
//

import Tools4SwiftUI

struct GridView: View {
    
    let dataSet: DicomDataSet
    
    private let gridItemLayout = [ GridItem(.flexible()),
                                   GridItem(.flexible()),
                                   GridItem(.flexible()) ]
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(AppModel.self) private var appModel
    
    @State private var metadataIsShown: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                LazyVGrid(columns: gridItemLayout, spacing: 10) {
                    
                    ForEach(dataSet.files) { file in
                        
                        NavigationLink(value: file) {
                            ImageView(
                                dicomFile: file,
                                isDetail: false,
                                metadataIsShown: metadataIsShown,
                            )
                            .frame(minWidth: 150, minHeight: 150)
                        }
                        .id(file)
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationDestination(for: DicomFile.self) { file in
                
                ImageView(
                    dicomFile: file,
                    isDetail: true,
                    metadataIsShown: metadataIsShown,
                )
                .navigationTitle(file.url.lastPathComponent)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Toggle("Metadata", isOn: $metadataIsShown)
                            .toggleStyle(.button)
                    }
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .automatic) {
                    
                    AsyncButton("3D Visualization") {
                        
                        if appModel.immersiveSpaceState == .closed {
                            appModel.immersiveSpaceState = .inTransition
                            await openImmersiveSpace(id: "immersiveSpace")
                        }
                        
                        try await appModel.addDicom3DEntity(using: dataSet)
                        
                        openWindow(id: "controlPanel", value: dataSet)
                    }
                    .disabled(appModel.entities.contains(where: { $0.name == dataSet.id.uuidString }))
                }
            }
        }
    }
}
