//
//  ImageLoaderInteractorSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

import Foundation
@testable import CuteDogs

final class ImageLoaderInteractorSpy: ImageLoaderInteractor {
    
    var fetchImageAction: (URL) throws -> (Data?) = { _ in return nil}
    func fetchImage(imageURL: URL) async throws -> Data? {
        try fetchImageAction(imageURL)
    }
}
