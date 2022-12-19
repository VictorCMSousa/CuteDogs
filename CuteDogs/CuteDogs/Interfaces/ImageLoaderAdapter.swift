//
//  ImageLoaderAdapter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 18/12/2022.
//

import Foundation

final class ImageLoaderAdapter: ImageLoaderInteractor {
    
    
    private let imageLoader: ImageLoaderInteractor
    private let cacheLoader: ImageCache & ImageLoaderInteractor
    
    init(imageLoader: ImageLoaderInteractor, cacheLoader: ImageCache & ImageLoaderInteractor) {
        self.imageLoader = imageLoader
        self.cacheLoader = cacheLoader
    }
    
    func fetchImage(imageURL: URL) async throws -> Data? {
        
        if let imageData = try? await cacheLoader.fetchImage(imageURL: imageURL) {
            return imageData
        }
        guard let imageData = try await imageLoader.fetchImage(imageURL: imageURL) else {
            return nil
        }
        cacheLoader.save(imageData, for: imageURL)
        return imageData
    }
}
