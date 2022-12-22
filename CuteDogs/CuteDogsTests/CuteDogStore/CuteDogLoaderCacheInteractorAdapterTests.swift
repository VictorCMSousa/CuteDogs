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
        var capturedSize = 0
        var capturedPageNumber = 0
        
        remoteInteractor.fetchBreedsAction = { size, pgNumber in
            capturedSize = size
            capturedPageNumber = pgNumber
            return []
        }
        
        let _ = try await sut.fetchCuteDogs(size: 10, pageNumber: 10)
        
        XCTAssertEqual(capturedSize, 10)
        XCTAssertEqual(capturedPageNumber, 10)
    }
    
    func test_fetchCuteDogs_returnRemoteResponse() async throws {
        
        let remoteInteractor = DogBreedsInteractorSpy()
        let cacheInteractor = DogBreedsCacheIntaractorSpy()
        let sut = makeSUT(remoteInteractor: remoteInteractor, cacheInteractor: cacheInteractor)
        
        remoteInteractor.fetchBreedsAction = { _, _ in
            [.anyDogBreed]
        }
        
        let feched = try await sut.fetchCuteDogs(size: 10, pageNumber: 10)
        
        XCTAssertEqual(feched, [.anyDogBreed])
    }
    
    func test_fetchCuteDogs_saveCacheAfterRemoteSuccess() async throws {
        
        let remoteInteractor = DogBreedsInteractorSpy()
        let cacheInteractor = DogBreedsCacheIntaractorSpy()
        let sut = makeSUT(remoteInteractor: remoteInteractor, cacheInteractor: cacheInteractor)
        
        remoteInteractor.fetchBreedsAction = { _, _ in
            [.anyDogBreed]
        }
        
        let _ = try await sut.fetchCuteDogs(size: 10, pageNumber: 10)
        
        XCTAssertEqual(cacheInteractor.savedDogs, [.anyDogBreed])
    }
    
    func test_fetchCuteDogs_askCacheIfRemoteFailInitialLoader() async throws {
        
        let remoteInteractor = DogBreedsInteractorSpy()
        let cacheInteractor = DogBreedsCacheIntaractorSpy()
        let sut = makeSUT(remoteInteractor: remoteInteractor, cacheInteractor: cacheInteractor)
        
        remoteInteractor.fetchBreedsAction = { _, _ in
            throw ApiError.apiError
        }
        
        cacheInteractor.fetchCuteDogsAction = { [.anyDogBreed] }
        let fetched = try await sut.fetchCuteDogs(size: 10, pageNumber: 0)
        
        XCTAssertEqual(cacheInteractor.savedDogs, [])
        XCTAssertEqual(fetched, [.anyDogBreed])
    }
    
    func test_fetchCuteDogs_notAskCacheIfRemoteFailNotInitialLoader() async throws {
        
        let remoteInteractor = DogBreedsInteractorSpy()
        let cacheInteractor = DogBreedsCacheIntaractorSpy()
        let sut = makeSUT(remoteInteractor: remoteInteractor, cacheInteractor: cacheInteractor)
        
        remoteInteractor.fetchBreedsAction = { _, _ in
            throw ApiError.apiError
        }
        
        cacheInteractor.fetchCuteDogsAction = { [.anyDogBreed] }
        let fetched = try await sut.fetchCuteDogs(size: 10, pageNumber: 10)
        
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
