//
//  URL.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 12/11/24.
//

import Foundation

extension URL {
    
    /// The base directory where all DICOM datasets are cached.
    ///
    /// This defaults to the user's caches directory. If unavailable, it falls back to the temporary directory.
    static let cacheDirectory: URL = {
        return FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory
    }()
    
    /// Executes a closure while safely accessing a security-scoped resource.
    ///
    /// This method wraps the provided closure with calls to start and stop
    /// security-scoped resource access on the URL. It first attempts to start
    /// accessing the resource by calling `startAccessingSecurityScopedResource()`.
    /// If access is granted, a `defer` block ensures that `stopAccessingSecurityScopedResource()`
    /// is called once the closure has completed—whether it succeeds or throws.
    ///
    /// - Parameter handler: A closure that performs operations on the resource.
    ///   It can throw an error and returns a value of type `T`.
    ///
    /// - Returns: The value returned by the `handler` closure.
    ///
    /// - Throws: Re-throws any error thrown by the `handler` closure.
    ///
    /// Usage:
    ///
    ///     let result = try fileURL.whileAccessingSecurityScopedResource {
    ///         // Perform file operations here while the resource is accessible.
    ///         return processFile(at: fileURL)
    ///     }
    func whileAccessingSecurityScopedResource<T>(handler: () throws -> T) rethrows -> T {
        
        // Attempt to start accessing the security-scoped resource.
        let accessingScopedResource = self.startAccessingSecurityScopedResource()
        
        // Ensure that access is stopped after the handler executes.
        defer {
            if accessingScopedResource {
                self.stopAccessingSecurityScopedResource()
            }
        }
        
        // Execute the handler closure while the resource is accessible.
        return try handler()
    }
}
