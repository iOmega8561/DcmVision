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
//  DcmVisionApp.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

import SwiftUI
import RealityKitContent

@main
struct DcmVisionApp: App {
                
    @State private var appModel = AppModel()
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .frame(
                    minWidth: 1000,
                    minHeight: 500
                )
                .environment(appModel)
        }
        .windowResizability(.contentSize)
        
        WindowGroup(id: "controlPanel", for: DicomDataSet.self) { $value in
            
            if let value {
                ControlPanel(dataSet: value)
                    .frame(
                        width: 500,
                        height: 100
                    )
                    .environment(appModel)
            }
        }
        .windowResizability(.contentSize)
        
        ImmersiveSpace(id: "immersiveSpace") {
            ModelView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
    }
    
    init() {
        RealityKitContent.GestureComponent.registerComponent()
        appModel.bootstrap()
    }
}
