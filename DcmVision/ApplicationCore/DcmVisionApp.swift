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
            
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .frame(
                    minWidth: 1000,
                    minHeight: 500
                )
        }
        .windowResizability(.contentSize)
        
        ImmersiveSpace(id: "3Dmodel", for: DicomDataSet.self) { value in
            
            if let dataSet = value.wrappedValue {
                ModelView(dataSet: dataSet)
            }
        }
    }
    
    init() {
        RealityKitContent.GestureComponent.registerComponent()
    }
}
