//
//  Entity.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 30/04/25.
//

import Foundation
import RealityKit

public extension Entity {
    
    var gestureComponent: GestureComponent? {
        get { components[GestureComponent.self] }
        set { components[GestureComponent.self] = newValue }
    }
    
    /// Returns the position of the entity specified in the app's coordinate system. On
    /// iOS and macOS, which don't have a device native coordinate system, scene
    /// space is often referred to as "world space".
    var scenePosition: SIMD3<Float> {
        get { position(relativeTo: nil) }
        set { setPosition(newValue, relativeTo: nil) }
    }
    
    /// Returns the orientation of the entity specified in the app's coordinate system. On
    /// iOS and macOS, which don't have a device native coordinate system, scene
    /// space is often referred to as "world space".
    var sceneOrientation: simd_quatf {
        get { orientation(relativeTo: nil) }
        set { setOrientation(newValue, relativeTo: nil) }
    }
    
    func setDirectGestures(enabled: Bool) {
        
        guard var component = self.gestureComponent else {
            
            #if DEBUG
            print("No gesture component found on entity with ID: \(self.id)")
            #endif
            
            return
        }
        
        component.canDrag = enabled
        component.canRotate = enabled
        component.canScale = enabled
        component.pivotOnDrag = enabled
        component.preserveOrientationOnPivotDrag = enabled
    }
}
