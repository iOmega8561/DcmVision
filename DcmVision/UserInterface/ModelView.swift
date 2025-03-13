//
//  ModelView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 03/03/25.
//

import SwiftUI

import RealityKit

struct ModelView: View {
            
    let directoryURL: URL
    
    @State private var modelEntity: Entity? = nil
    
    var body: some View {
        
        RealityView { _ in
            
            Task { await loadModel() }
            
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
        .overlay { if modelEntity == nil { LoadingView() } }
    }
    
    func loadModel() async {
        
        do {
            let visualizationToolkit: VisualizationToolkit = try .init()
            
            let dicom3DURL: URL = try visualizationToolkit.generateDICOM(
                fromDirectory: directoryURL,
                withName: directoryURL.lastPathComponent,
                threshold: 300.0
            )
            
            modelEntity = try await Entity(
                contentsOf: dicom3DURL
            )
                
        } catch { print(error.localizedDescription) }
    }
}
