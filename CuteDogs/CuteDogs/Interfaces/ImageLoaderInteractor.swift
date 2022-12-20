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

protocol ImageCacheLoaderInteractor: ImageLoaderInteractor {
    
    func save(_ data: Data, for url: URL)
}
