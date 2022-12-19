//
//  ImageCache.swift
//  CuteDogs
//
//  Created by Victor Sousa on 18/12/2022.
//

import Foundation

final class ImageCacheLoader: ImageLoaderInteractor, ImageCache {
    
    private let myQueue = DispatchQueue(label: "my.imageCache", attributes: .concurrent)
    private var cache = [URL: Data]()
    
    func fetchImage(imageURL: URL) async throws -> Data? {
        myQueue.sync {
            cache[imageURL]
        }
    }
    
    func save(_ data: Data, for url: URL) {
        myQueue.async(flags: .barrier) { [weak self] in
            self?.cache[url] = data
        }
    }
}
