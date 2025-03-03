//
//  ModelView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 03/03/25.
//

import SwiftUI

import RealityKit

struct ModelView: View {
            
    @State private var modelEntity: Entity? = nil
    
    var body: some View {
        
        RealityView { content in
            
            if let modelEntity {
                                
                modelEntity.transform.scale = [0.0015, 0.0015, 0.0015]
                
                modelEntity.transform.rotation = .init(
                    angle: -.pi*1.5,
                    axis: [1, 0, 0]
                )
                
                content.add(modelEntity)
            }
        }
        .onAppear {
            
            do {
                let visualizationToolkit: VisualizationToolkit = try .init()
                
                let dicom3DURL: URL = try visualizationToolkit.generateDICOM(
                    fromDirectory: Bundle.main.resourceURL!.appendingPathComponent("DICOM"),
                    withName: "Dicom3DTest",
                    threshold: 300.0
                )
                
                modelEntity = try Entity.load(
                    contentsOf: dicom3DURL
                )
                    
            } catch { print(error.localizedDescription) }
        }
    }
}
