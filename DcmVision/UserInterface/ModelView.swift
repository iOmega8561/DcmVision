//
//  ModelView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 03/03/25.
//

import SwiftUI

import RealityKit

struct ModelView: View {
            
    let dataSet: DicomDataSet
    
    @State private var error: Error? = nil
    @State private var modelEntity: Entity? = nil
    
    var body: some View {
        
        RealityView { _ in
            
            Task {
                do {
                    modelEntity = try await bootstrap()
                    
                } catch { self.error = error }
            }
            
        } update: { content in
            
            if let modelEntity {
                                
                modelEntity.transform.scale = [0.0015, 0.0015, 0.0015]
                
                modelEntity.transform.rotation = .init(
                    angle: -.pi*1.5,
                    axis: [1, 0, 0]
                )
                
                content.add(modelEntity)
            }
        }
        .overlay {
            if modelEntity == nil, let error {
                ErrorView(error: error)
                
            } else if modelEntity == nil { LoadingView() }
        }
    }
    
    func bootstrap() async throws -> Entity {
        
        let visualizationToolkit: VisualizationToolkit = .init()
        
        let dicom3DURL: URL = try visualizationToolkit.generateDICOM(
            fromDirectory: dataSet.url,
            withName: dataSet.name,
            threshold: 300.0
        )
        
        let modelEntity = try await ModelEntity(contentsOf: dicom3DURL)
        
        modelEntity.model?.materials = [
            SimpleMaterial(color: .white, isMetallic: false)
        ]
        
        return modelEntity
    }
}
