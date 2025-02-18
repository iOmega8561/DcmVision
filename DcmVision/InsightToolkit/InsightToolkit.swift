//
//  InsightToolkit.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 18/02/25.
//

struct InsightToolkit {
    
    private let cacheDirectory: URL
    
    private let insightToolkit: ITKWrapper
    
    func loadDICOM(withName fileName: String) throws {
        
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "dcm"
            
        ) else { throw DcmVisionError.fileNotFound }
        
        insightToolkit.loadDICOMat(
            url.path(percentEncoded: false)
        )
    }
    
    init() {
        cacheDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first!
        
        insightToolkit = .init(cacheDirectoryURL: cacheDirectory)
    }
}
