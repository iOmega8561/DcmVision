//
//  ContentView.swift
//  DicomTest
//
//  Created by Giuseppe Rocco on 09/12/24.
//

import SwiftUI
import RealityKit

import SwiftUI

struct ContentView: View {
    @State private var dicomImage: Image? = nil
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            if let dicomImage = dicomImage {
                dicomImage
                    .resizable()
                    .scaledToFit()
            } else if let errorMessage = errorMessage {
                Text("Errore: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                ProgressView("Caricamento...")
            }
        }
        .onAppear { loadDICOMImage() }
    }
    
    private func loadDICOMImage() {
        // Assumiamo che il file si chiami "immagine.dcm" e sia nella cartella Resources
        guard let url = Bundle.main.url(forResource: "1-01", withExtension: "dcm") else {
            self.errorMessage = "File DICOM non trovato."
            return
        }
        
        let imagePath = DcmDecoder.toPng(
            url.path(percentEncoded: false)
        )
        
        if let imagePath,
           let imageData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)),
           let uiImage = UIImage(data: imageData) {
            self.dicomImage = Image(uiImage: uiImage)
        } else {
            errorMessage = "Failed to load decoded image"
        }
        
    }
}
