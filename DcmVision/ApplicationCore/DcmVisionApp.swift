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
            
    @State private var alertForDemo = !UserDefaults.standard.bool(forKey: "alert")
    
    @State private var appModel = AppModel()
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .frame(
                    minWidth: 1000,
                    minHeight: 500
                )
                .environment(appModel)
                .alert("⚠️ Welcome to DcmVision ⚠️", isPresented: $alertForDemo) {
                    Button("OK") {
                        UserDefaults.standard.set(true, forKey: "alert")
                        alertForDemo = false
                    }
                } message: {
                    Text("This is a technical demo. Although functional it is best to use it in a controlled environment. This tool is not intended for clinical use and should not be used for medical diagnosis or treatment.")
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
