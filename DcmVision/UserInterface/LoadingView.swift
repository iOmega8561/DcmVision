//
//  LoadingView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 13/03/25.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        
        VStack {
            
            ProgressView()
                .scaleEffect(3.0)
            
            Spacer()
                .frame(height: 100)
            
            Text("Loading DICOM data...")
                .font(.largeTitle)
        }
        .frame(width: 400, height: 300)
        .glassBackgroundEffect()
    }
}
