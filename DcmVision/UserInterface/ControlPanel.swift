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
