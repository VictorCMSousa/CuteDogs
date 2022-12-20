//
//  ImageLoaderAdapterTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 20/12/2022.
//

import XCTest
@testable import CuteDogs

final class ImageLoaderAdapterTests: XCTestCase {
    
    func test_fetchImageCacheEmpty_askImageNetworkLoader() async {
        
        let imageLoader = ImageLoaderInteractorSpy()
        let sut = makeSUT(imageLoader: imageLoader)
        var capturedURL: URL? = nil
        imageLoader.fetchImageAction = { url in
            capturedURL = url
            return nil
        }
        
        let _ = try? await sut.fetchImage(imageURL: .any)
        
        XCTAssertEqual(capturedURL, .any)
    }
    
    func test_fetchImageCacheEmptyNetworkError_returnNil() async {
        
        let imageLoader = ImageLoaderInteractorSpy()
        let sut = makeSUT(imageLoader: imageLoader)
        imageLoader.fetchImageAction = { url in
            throw ApiError.apiError
        }
        
        let fetched = try? await sut.fetchImage(imageURL: .any)
        
        XCTAssertNil(fetched)
    }
    
    func test_fetchImageCacheNotEmpty_preventImageNetworkLoader() async {
        
        let imageLoader = ImageLoaderInteractorSpy()
        let cacheLoader = ImageCacheLoaderInteractorSpy()
        let sut = makeSUT(imageLoader: imageLoader, cacheLoader: cacheLoader)
        
        cacheLoader.save(Data(), for: .any)
        
        var capturedURL: URL? = nil
        imageLoader.fetchImageAction = { url in
            capturedURL = url
            return nil
        }
        
        let _ = try? await sut.fetchImage(imageURL: .any)
        
        XCTAssertNil(capturedURL)
    }
    
    func test_fetchImageCacheNotEmpty_loadImageFromCache() async {
        
        let cacheLoader = ImageCacheLoaderInteractorSpy()
        let sut = makeSUT(cacheLoader: cacheLoader)
        let anyData = Data.fiveBreeds
        cacheLoader.save(anyData, for: .any)
        
        let fetched = try? await sut.fetchImage(imageURL: .any)
        
        XCTAssertEqual(fetched, anyData)
    }
    
    func test_fetchImageCacheEmpty_saveImageCache() async {
        
        let imageLoader = ImageLoaderInteractorSpy()
        let cacheLoader = ImageCacheLoaderInteractorSpy()
        let sut = makeSUT(imageLoader: imageLoader, cacheLoader: cacheLoader)
        let anyData = Data.fiveBreeds
        
        imageLoader.fetchImageAction = { _ in
            anyData
        }
        
        let _ = try? await sut.fetchImage(imageURL: .any)
        
        XCTAssertEqual(cacheLoader.cache[.any], anyData)
    }
    
    func makeSUT(imageLoader: ImageLoaderInteractor = ImageLoaderInteractorSpy(),
                 cacheLoader: ImageCacheLoaderInteractor = ImageCacheLoaderInteractorSpy(),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> ImageLoaderAdapter {
        
        let sut = ImageLoaderAdapter(imageLoader: imageLoader,
                                     cacheLoader: cacheLoader)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

final class ImageCacheLoaderInteractorSpy: ImageCacheLoaderInteractor {
    
    var cache = [URL: Data]()
    
    func save(_ data: Data, for url: URL) {
        cache[url] = data
    }
    
    func fetchImage(imageURL: URL) async throws -> Data? {
        cache[imageURL]
    }
}
