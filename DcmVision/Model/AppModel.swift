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
    private(set) var dataSets: [DicomDataSet] = []
    
    @MainActor
    var immersiveSpaceState: ImmersiveSpaceState = .closed
    
    @MainActor
    func bootstrap() {
        guard let cachedContent = try? FileManager.default.contentsOfDirectory(
            at: .cacheDirectory,
            includingPropertiesForKeys: nil
        ) else { return }
        
        dataSets = cachedContent.compactMap {
            guard let uuid = UUID(uuidString: $0.lastPathComponent),
                  let files = try? DicomFile.parseDirectory(at: $0) else {
                return nil
            }
            
            return DicomDataSet(id: uuid, files: files)
        }
    }
    
    @Sendable @discardableResult
    func addDataSet(from origin: URL) async throws -> DicomDataSet {
        let newDataSet = try DicomDataSet.createNew(originURL: origin)
        
        await MainActor.run {
            dataSets.append(newDataSet)
        }
        
        return newDataSet
    }
    
    @Sendable
    func removeDataSet(_ dataSet: DicomDataSet) async throws {
        try FileManager.default.removeItem(at: dataSet.url)
        
        await MainActor.run {
            dataSets.removeAll(where: { $0 == dataSet })
        }
        
        await removeDicom3DEntity(using: dataSet)
    }
    
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
    func removeDicom3DEntity(using dataSet: DicomDataSet) async {
        
        await MainActor.run {
            entities.removeAll(where: { $0.name == dataSet.id.uuidString })
        }
    }
}
