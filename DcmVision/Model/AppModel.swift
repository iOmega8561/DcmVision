//
//  Copyright (C) 2025  Giuseppe Rocco
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//  ----------------------------------------------------------------------
//
//  AppModel.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 02/05/25.
//

import SwiftUI
import RealityKit

@MainActor @Observable
final class AppModel: Sendable {
    
    private(set) var entities: [Entity] = []
    
    private(set) var dataSets: [DicomDataSet] = []
    
    var immersiveSpaceState: ImmersiveSpaceState = .closed
    
    var realityContent: RealityViewContent?
    
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
    
    @discardableResult
    func addDataSet(from origin: URL) throws -> DicomDataSet {
        let newDataSet = try DicomDataSet.createNew(originURL: origin)
        
        dataSets.append(newDataSet)
        return newDataSet
    }
    
    func removeDataSet(_ dataSet: DicomDataSet) throws {
        try FileManager.default.removeItem(at: dataSet.url)
        
        dataSets.removeAll(where: { $0 == dataSet })
        
        try removeDicom3DEntity(using: dataSet)
    }
    
    func setEntityGestures(for dataSet: DicomDataSet, enabled: Bool) throws {
        let entity = entities.first(where: { $0.name == dataSet.id.uuidString })
        
        guard let entity else {
            throw DcmVisionError.entityNotFound
        }
        entity.setDirectGestures(enabled: enabled)
    }
    
    func removeDicom3DEntity(using dataSet: DicomDataSet) throws {
        let entity = entities.first(where: { $0.name == dataSet.id.uuidString })
        
        guard let entity else {
            throw DcmVisionError.entityNotFound
        }
        
        realityContent?.remove(entity)
        entities.removeAll(where: { $0.name == dataSet.id.uuidString })
    }
    
    @Sendable nonisolated
    func addDicom3DEntity(using dataSet: DicomDataSet) async throws {
        
        try await MainActor.run {
            guard !entities.contains(where: { $0.name == dataSet.id.uuidString }) else {
                throw DcmVisionError.entityAlreadyExists
            }
        }
        
        let isoSurface = try dataSet.isoSurface(huThreshold: 300)
        let modelEntity = try await ModelEntity.fromIsoSurface(at: isoSurface)
        
        await MainActor.run {
            modelEntity.name = dataSet.id.uuidString
            entities.append(modelEntity)
        }
    }
}
