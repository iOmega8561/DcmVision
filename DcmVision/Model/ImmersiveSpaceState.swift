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
