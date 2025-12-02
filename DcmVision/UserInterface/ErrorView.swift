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
