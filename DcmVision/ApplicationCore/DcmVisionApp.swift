//
//  DcmVisionApp.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

import SwiftUI

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
        
        WindowGroup(id: "volume", for: DicomDataSet.self) { value in
            
            if let dataSet = value.wrappedValue {
                ModelView(dataSet: dataSet)
            }
        }
        .windowStyle(.volumetric)
     }
}
