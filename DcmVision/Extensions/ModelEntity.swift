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
//  ModelEntity.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 30/04/25.
//

import RealityKit
import RealityKitContent

extension ModelEntity {
    
    /// Creates a `ModelEntity` from an isosurface mesh file, applies default styling,
    /// reorients and recenters it for immersive display, and enables interaction.
    ///
    /// - Parameter url: The file URL pointing to a 3D isosurface asset (e.g., a PLY exported
    ///   from VTK’s Marching Cubes, later converted to USD).
    /// - Returns: A fully configured `ModelEntity` ready for insertion into an AR/VR scene.
    /// - Throws: Any errors thrown when loading the model contents at the given URL.
    ///
    /// This helper performs the following steps:
    /// 1. Loads the 3D model asynchronously from the provided URL.
    /// 2. Rotates it by -270° (−3π/2 radians) around the X-axis so it sits upright in the scene.
    /// 3. Applies a simple non-metallic white material for clear visibility.
    /// 4. Computes its visual bounds and moves the entity so its base rests ~1.5m above the origin,
    ///    and slightly offset backward (−Z) so it appears comfortably in front of the user.
    /// 5. Enables indirect input targeting, generates collision shapes for physics/interaction,
    ///    and attaches default gesture handling.
    ///
    /// Use this when you need an out-of-the-box, interaction-ready ModelEntity from your custom
    /// isosurface data, perfectly scaled and positioned for Apple Vision Pro / RealityKit scenes.
    static func fromIsoSurface(at url: URL) async throws -> ModelEntity {
        
        let modelEntity = try await ModelEntity(contentsOf: url)
        
        modelEntity.transform.rotation = .init(
            angle: -.pi * 1.5,
            axis: [1, 0, 0]
        )
        
        modelEntity.model?.materials = [
            SimpleMaterial(color: .white, isMetallic: false)
        ]
        
        let bounds = modelEntity.visualBounds(relativeTo: nil)
        let center = bounds.center

        modelEntity.position = [
            -center.x,
            -center.y + 1.5,
            -center.z - 1.5
        ]
        
        modelEntity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        modelEntity.generateCollisionShapes(recursive: true)
        modelEntity.components.set(GestureComponent())
        
        return modelEntity
    }
}
