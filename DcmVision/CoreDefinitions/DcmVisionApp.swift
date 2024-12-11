//
//  DcmVisionApp.mm
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
                    minWidth: 500,
                    maxWidth: 1250,
                    minHeight: 100
                )
        }
        .windowResizability(.contentSize)
     }
}
