//
//  ErrorView.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 13/03/25.
//

import SwiftUI

struct ErrorView: View {
    
    private let errorDescription: String?
    
    var body: some View {
        
        VStack {
            
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 100, maxHeight: 100)
                .foregroundStyle(.yellow)
            
            if let errorDescription {
                Spacer()
                    .frame(height: 50)
                
                Text(errorDescription)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .frame(
            minWidth: errorDescription != nil ? 400 : nil,
            idealWidth: errorDescription != nil ? 400 : nil,
            maxWidth: 400,
            minHeight: errorDescription != nil ? 300 : nil,
            idealHeight: errorDescription != nil ? 300 : nil
        )
        .frame(
            width: errorDescription == nil ? 150 : nil,
            height: errorDescription == nil ? 150 : nil
        )
        .glassBackgroundEffect()
    }
    
    init(error: String) { self.errorDescription = error }
    
    init(error: Error) { self.errorDescription = error.localizedDescription }
    
    init() { self.errorDescription = nil }
}
