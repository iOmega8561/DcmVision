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
                .frame(width: 300, height: 300)
        }
        .windowResizability(.contentSize)
        
        WindowGroup(id: "dicom", for: URL.self) { url in
            
            if let directoryURL = url.wrappedValue {
                GridStackView(directoryURL: directoryURL)
                    .frame(
                        minWidth: 500,
                        maxWidth: 1250,
                        minHeight: 500
                    )
            }
        }
        .windowResizability(.contentSize)
        
        WindowGroup(id: "volume", for: URL.self) { url in
            
            if let directoryURL = url.wrappedValue {
                ModelView(directoryURL: directoryURL)
            }
        }
        .windowStyle(.volumetric)
     }
}
