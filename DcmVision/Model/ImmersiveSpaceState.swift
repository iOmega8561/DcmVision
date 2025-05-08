//
//  ImmersiveSpaceState.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 02/05/25.
//

/// Represents the current state of an immersive space session.
///
/// This enum is typically used to track the lifecycle of a 3D or full-screen immersive environment,
/// such as in a visionOS or AR/VR context.
enum ImmersiveSpaceState {
    
    /// The immersive space is not active or visible.
    case closed
    
    /// The immersive space is currently transitioning (e.g., opening or closing).
    case inTransition
    
    /// The immersive space is fully active and visible to the user.
    case open
}
