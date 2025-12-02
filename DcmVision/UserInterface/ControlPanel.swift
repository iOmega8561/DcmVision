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
//  ControlPanel.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 16/05/25.
//

import Tools4SwiftUI
import RealityKitContent

struct ControlPanel: View {
    
    let dataSet: DicomDataSet
    
    @Environment(AppModel.self) private var appModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var entityIsLocked: Bool = false
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 50) {
            
            Text(dataSet.name)
                .font(.headline)
                .lineLimit(1)
            
            HStack(spacing: 30) {
                
                Toggle("Lock 3D", systemImage: entityIsLocked ? "lock" : "lock.open",
                       isOn: $entityIsLocked)
                .toggleStyle(.button)
                
                AsyncButton("Remove 3D", systemImage: "xmark", role: .destructive) {
                    try appModel.removeDicom3DEntity(using: dataSet)
                    dismiss()
                }
            }
        }
        .onChange(of: entityIsLocked) { _, new in
            try? appModel.setEntityGestures(for: dataSet, enabled: !new)
        }
    }
}
