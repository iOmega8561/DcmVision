//
//  ModelView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 03/03/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ModelView: View {
                
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        
        RealityView { _ in } update: { content in
            
            for entity in appModel.entities {
                content.add(entity)
            }
        }
        .installGestures()
    }
}
