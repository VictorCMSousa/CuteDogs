//
//  ImageLoaderInteractor.swift
//  CuteDogs
//
//  Created by Victor Sousa on 18/12/2022.
//

import Foundation

protocol ImageLoaderInteractor {
    
    func fetchImage(imageURL: URL) async throws -> Data?
}

protocol ImageCache {
    
    func save(_ image: Data, for url: URL)
}
