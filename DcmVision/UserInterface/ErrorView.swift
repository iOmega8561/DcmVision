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
                
                Text(errorDescription)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding([.horizontal, .top])
            }
        }
    }
    
    init(error: String) { self.errorDescription = error }
    
    init(error: Error) { self.errorDescription = error.localizedDescription }
    
    init() { self.errorDescription = nil }
}
