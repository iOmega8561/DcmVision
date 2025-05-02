//
//  GridContainerView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 09/12/24.
//

import Tools4SwiftUI

struct GridContainerView: View {
    
    let dataSet: DicomDataSet
    
    @State private var dicomURLs: [URL]? = nil
    @State private var error: String? = nil
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        
        if let dicomURLs {
            
            GridView(dicomURLs: dicomURLs)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        
                        AsyncButton("3D Visualization") {
                            
                            if appModel.immersiveSpaceState == .closed {
                                appModel.immersiveSpaceState = .inTransition
                                await openImmersiveSpace(id: "immersiveSpace")
                            }
                            
                            try await appModel.addDicom3DEntity(using: dataSet)
                        }
                    }
                }
            
        } else if let error {
            ErrorView(error: error)
            
        } else {
            
            LoadingView()
                .onAppear {
                    
                    Task.detached(priority: .utility) {
                        do {
                            let sortedSlices = try dataSet.sortedSlices()
                            
                            await MainActor.run { self.dicomURLs = sortedSlices }
                            
                        } catch { await MainActor.run { self.error = error.localizedDescription } }
                    }
                }
        }
    }
}
