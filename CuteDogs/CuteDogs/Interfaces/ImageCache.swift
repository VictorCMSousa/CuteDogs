//
//  ImageCache.swift
//  CuteDogs
//
//  Created by Victor Sousa on 18/12/2022.
//

import Foundation

final class ImageCacheLoader: ImageLoaderInteractor, ImageCache {
    
    private let myQueue = DispatchQueue(label: "my.imageCache", attributes: .concurrent)
    
    func fetchImage(imageURL: URL) async throws -> Data? {
        myQueue.sync {
            try? imageFromFileSystem(for: imageURL)
        }
    }
    
    func save(_ data: Data, for url: URL) {
        myQueue.async(flags: .barrier) { [weak self] in
            try? self?.persistImage(data, url: url)
        }
    }
    private func imageFromFileSystem(for urlRequest: URL) throws -> Data? {
        guard let url = fileName(for: urlRequest) else { return nil }

        return try Data(contentsOf: url)
    }
    
    private func persistImage(_ data: Data, url: URL) throws {
        guard let filename = fileName(for: url) else { return }
        try data.write(to: filename)
    }
    
    private func fileName(for url: URL) -> URL? {
        guard let fileName = url.lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        return applicationSupport.appendingPathComponent(fileName)
    }
}
