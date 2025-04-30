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
            
    let dataSet: DicomDataSet
    
    @State private var error: Error? = nil
    @State private var modelEntity: Entity? = nil
    
    var body: some View {
        
        RealityView { _ in
            
            Task.detached(priority: .utility) {
                
                do {
                
                    let isoSurface = try dataSet.isoSurface(huThreshold: 300)
                    let modelEntity = try await ModelEntity.fromIsoSurface(at: isoSurface)
                    
                    await MainActor.run {
                        self.modelEntity = modelEntity
                    }
                    
                } catch {
                    
                    await MainActor.run { self.error = error }
                }
            }
        } update: { content in
            
            if let modelEntity {
                
                content.add(modelEntity)
            }
        }
        .installGestures()
    }
}
