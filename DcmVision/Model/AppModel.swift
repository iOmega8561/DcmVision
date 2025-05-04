//
//  AppModel.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 02/05/25.
//

import Combine
import RealityKit

@Observable
final class AppModel: Sendable {
    
    @MainActor
    private(set) var entities: [Entity] = []
    
    @MainActor
    var dataSets: [DicomDataSet] = []
    
    @MainActor
    var immersiveSpaceState: ImmersiveSpaceState = .closed
    
    @Sendable
    func addDicom3DEntity(using dataSet: DicomDataSet) async throws {
        
        let isoSurface = try dataSet.isoSurface(huThreshold: 300)
        let modelEntity = try await ModelEntity.fromIsoSurface(at: isoSurface)
        
        await MainActor.run {
            modelEntity.name = dataSet.id.uuidString
            entities.append(modelEntity)
        }
    }
    
    @Sendable
    func remodeDicom3DEntity(using dataSet: DicomDataSet) async throws {
        
        await MainActor.run {
            entities.removeAll(where: { $0.name == dataSet.id.uuidString })
        }
    }
}
