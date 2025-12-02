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
//  ModelView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 03/03/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ModelView: View {
                
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        
        RealityView { content in
            
            appModel.realityContent = content
            
        } update: { content in
            
            for entity in appModel.entities {
                content.add(entity)
            }
        }
        .installGestures()
    }
}
