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
    }
}
