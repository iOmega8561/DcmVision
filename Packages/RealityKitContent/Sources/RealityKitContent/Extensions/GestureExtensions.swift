/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
App-specific extension on Gesture.
*/

import Foundation
import RealityKit
import SwiftUI

// MARK: - Rotate -

/// Gesture extension to support rotation gestures.
public extension Gesture where Value == EntityTargetValue<RotateGesture3D.Value> {
    
    /// Connects the gesture input to the `GestureComponent` code.
    func useGestureComponent() -> some Gesture {
        onChanged { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
//            value.entity.components[PhysicsBodyComponent.self] = .none
            value.entity.components[PhysicsBodyComponent.self]?.isAffectedByGravity = false
            
            gestureComponent.onChanged(value: value)
            
            value.entity.components.set(gestureComponent)
        }
        .onEnded { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
            gestureComponent.onEnded(value: value)
            
            value.entity.components.set(gestureComponent)
//            let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
//            let pb = PhysicsBodyComponent(material: material)
//            value.entity.components.set(pb)
            //value.entity.components[PhysicsBodyComponent.self]?.isAffectedByGravity = true
        }
    }
}

// MARK: - Drag -

/// Gesture extension to support drag gestures.
public extension Gesture where Value == EntityTargetValue<DragGesture.Value> {
    
    /// Connects the gesture input to the `GestureComponent` code.
    func useGestureComponent() -> some Gesture {
        onChanged { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
//            value.entity.components[PhysicsBodyComponent.self] = .none
            value.entity.components[PhysicsBodyComponent.self]?.isAffectedByGravity = false
            
            gestureComponent.onChanged(value: value)
            
            value.entity.components.set(gestureComponent)
        }
        .onEnded { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
            gestureComponent.onEnded(value: value)
            
            value.entity.components.set(gestureComponent)
//            let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
//            let pb = PhysicsBodyComponent(material: material)
//            value.entity.components.set(pb)
            //value.entity.components[PhysicsBodyComponent.self]?.isAffectedByGravity = true
        }
    }
}

// MARK: - Magnify (Scale) -

/// Gesture extension to support scale gestures.
public extension Gesture where Value == EntityTargetValue<MagnifyGesture.Value> {
    
    /// Connects the gesture input to the `GestureComponent` code.
    func useGestureComponent() -> some Gesture {
        onChanged { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
            value.entity.components[PhysicsBodyComponent.self]?.isAffectedByGravity = false
            
            gestureComponent.onChanged(value: value)
            
            value.entity.components.set(gestureComponent)
        }
        .onEnded { value in
            guard var gestureComponent = value.entity.gestureComponent else { return }
            
            gestureComponent.onEnded(value: value)
            
            value.entity.components.set(gestureComponent)
//            let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
//            let pb = PhysicsBodyComponent(material: material)
//            value.entity.components.set(pb)
            //value.entity.components[PhysicsBodyComponent.self]?.isAffectedByGravity = true
        }
    }
}
