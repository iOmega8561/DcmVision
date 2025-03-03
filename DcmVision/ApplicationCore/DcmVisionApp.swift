//
//  DcmVisionApp.mm
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

import SwiftUI

@main
struct DcmVisionApp: App {
        
    @Environment(\.openWindow) private var openWindow
    
    var body: some Scene {
        
        WindowGroup(id: "main") {
            
            ContentView()
                .frame(
                    minWidth: 500,
                    maxWidth: 1250,
                    minHeight: 100
                )
                .onAppear { openWindow(id: "volume") }
        }
        .windowResizability(.contentSize)
        
        WindowGroup(id: "volume") { ModelView() }
            .windowStyle(.volumetric)
     }
}
