//
//  CuteDogLoaderCacheInteractorAdapterTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 22/12/2022.
//

import XCTest
@testable import CuteDogs

final class CuteDogLoaderCacheInteractorAdapterTests: XCTestCase {
    
    func test_fetchCuteDogs_askRemoteLoader() async throws {
        
        let remoteInteractor = DogBreedsInteractorSpy()
        let sut = makeSUT(remoteInteractor: remoteInteractor)
        var capturedOffset = 0
        
        remoteInteractor.fetchMoreCuteDogsAction = { offset in
            capturedOffset = offset
            return []
        }
        
        let _ = try await sut.fetchMoreCuteDogs(offset: 0)
        
        XCTAssertEqual(capturedOffset, 0)
    }
    
    func test_fetchCuteDogs_returnRemoteResponse() async throws {
        
        let remoteInteractor = DogBreedsInteractorSpy()
        let cacheInteractor = DogBreedsCacheIntaractorSpy()
        let sut = makeSUT(remoteInteractor: remoteInteractor,
                          cacheInteractor: cacheInteractor)
        var cachedCount = 0
        
        remoteInteractor.fetchMoreCuteDogsAction = { _ in
            [.anyDogBreed]
        }
        
        cacheInteractor.fetchCuteDogsAction = {
            cachedCount += 1
            return []
        }
        
        let fetched = try await sut.fetchMoreCuteDogs(offset: 0)
        
        XCTAssertEqual(fetched, [.anyDogBreed])
        XCTAssertEqual(cachedCount, 0)
    }
    
    func test_fetchCuteDogs_saveCacheAfterRemoteSuccess() async throws {
        
        let remoteInteractor = DogBreedsInteractorSpy()
        let cacheInteractor = DogBreedsCacheIntaractorSpy()
        let sut = makeSUT(remoteInteractor: remoteInteractor, cacheInteractor: cacheInteractor)
        
        remoteInteractor.fetchMoreCuteDogsAction = { _ in
            [.anyDogBreed]
        }
        
        let _ = try await sut.fetchMoreCuteDogs(offset: 0)
        
        XCTAssertEqual(cacheInteractor.savedDogs, [.anyDogBreed])
    }
    
    func test_fetchCuteDogs_askCacheIfRemoteFailInitialLoader() async throws {
        
        let remoteInteractor = DogBreedsInteractorSpy()
        let cacheInteractor = DogBreedsCacheIntaractorSpy()
        let sut = makeSUT(remoteInteractor: remoteInteractor, cacheInteractor: cacheInteractor)
        
        remoteInteractor.fetchMoreCuteDogsAction = { _ in
            throw ApiError.apiError
        }
        
        cacheInteractor.fetchCuteDogsAction = { [.anyDogBreed] }
        let fetched = try await sut.fetchMoreCuteDogs(offset: 0)
        
        XCTAssertEqual(cacheInteractor.savedDogs, [])
        XCTAssertEqual(fetched, [.anyDogBreed])
    }
    
    func test_fetchCuteDogs_notAskCacheIfRemoteFailNotInitialLoader() async throws {
        
        let remoteInteractor = DogBreedsInteractorSpy()
        let cacheInteractor = DogBreedsCacheIntaractorSpy()
        let sut = makeSUT(remoteInteractor: remoteInteractor, cacheInteractor: cacheInteractor)
        
        remoteInteractor.fetchMoreCuteDogsAction = { _ in
            throw ApiError.apiError
        }
        
        cacheInteractor.fetchCuteDogsAction = { [.anyDogBreed] }
        let fetched = try await sut.fetchMoreCuteDogs(offset: 20)
        
        XCTAssertEqual(cacheInteractor.savedDogs, [])
        XCTAssertEqual(fetched, [])
    }
    
    func makeSUT(remoteInteractor: DogBreedsInteractor = DogBreedsInteractorSpy(),
                 cacheInteractor: DogBreedsCacheIntaractor = DogBreedsCacheIntaractorSpy(),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> DogBreedsInteractor {
        
        let sut = CuteDogLoaderCacheInteractorAdapter(remoteInteractor: remoteInteractor, cacheInteractor: cacheInteractor)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

final class DogBreedsCacheIntaractorSpy: DogBreedsCacheIntaractor {
    
    var savedDogs = [CuteDog]()
    func save(cuteDogs: [CuteDog]) {
        savedDogs.append(contentsOf: cuteDogs)
    }
    
    var fetchCuteDogsAction: () -> [CuteDog] = { return [] }
    func fetchCuteDogs() -> [CuteDog] {
        fetchCuteDogsAction()
    }
}
