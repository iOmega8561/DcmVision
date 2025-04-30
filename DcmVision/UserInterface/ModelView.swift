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
                    let modelEntity = try await ModelEntity(contentsOf: isoSurface)
                    
                    await MainActor.run {
                        
                        modelEntity.transform.scale = [0.0015, 0.0015, 0.0015]
                        
                        modelEntity.transform.rotation = .init(
                            angle: -.pi*1.5,
                            axis: [1, 0, 0]
                        )
                        
                        modelEntity.model?.materials = [
                            SimpleMaterial(color: .white, isMetallic: false)
                        ]
                        
                        let boundingBox = modelEntity.visualBounds(relativeTo: nil)
                        let boundingBoxCenter = boundingBox.center
                        
                        modelEntity.position = [
                            -boundingBoxCenter.x,
                            -boundingBoxCenter.y + 1.5,
                            -boundingBoxCenter.z - 1.5
                        ]
                        
                        modelEntity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                        modelEntity.generateCollisionShapes(recursive: true)
                        modelEntity.components.set(GestureComponent())
                        
                        modelEntity.setDirectGestures(enabled: true)
                        
                        self.modelEntity = modelEntity
                    }
                } catch { await MainActor.run { self.error = error } }
            }
            
        } update: { content in
            
            if let modelEntity {
                
                content.add(modelEntity)
            }
        }
        .installGestures()
    }
}
