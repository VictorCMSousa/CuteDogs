//
//  DogBreedsCacheIntaractorTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

import XCTest
@testable import CuteDogs

final class DogBreedsCacheIntaractorTests: XCTestCase {
    
    func test_fetchCuteDogs_returnEmptyOnEmptyCache() throws {
        
        let store = CuteDogStoreSpy()
        let sut = makeSUT(store: store)
        store.retrieveAction = { [] }
        
        let fetched = sut.fetchCuteDogs()
        
        XCTAssertEqual(fetched, [])
    }
    
    func test_fetchCuteDogs_returnEmptyCacheError() throws {
        
        let store = CuteDogStoreSpy()
        let sut = makeSUT(store: store)
        store.retrieveAction = { throw NSError(domain: "any", code: 0) }
            
        let fetched = sut.fetchCuteDogs()
        XCTAssertEqual(fetched, [])
        
    }
    
    func test_save_askStoreToSave() throws {
        
        let store = CuteDogStoreSpy()
        let sut = makeSUT(store: store)
        
        sut.save(cuteDogs: [.anyDogBreed])
            
        XCTAssertEqual(store.insertedDogs, [.anyDogBreed])
        
    }
    
    private func makeSUT(store: CuteDogStore = CuteDogStoreSpy(),
                         file: StaticString = #filePath,
                         line: UInt = #line) -> DogBreedsCacheIntaractor {
        
        let sut = LocalCuteDogInteractor(store: store)!
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

final class CuteDogStoreSpy: CuteDogStore {
    
    var retrieveAction: () throws -> [CuteDogStored]? = { return nil }
    func retrieve() throws -> [CuteDogStored]? {
        try retrieveAction()
    }
    
    var insertedDogs = [CuteDog]()
    func insert(cuteDogs: [CuteDog]) throws {
        insertedDogs.append(contentsOf: cuteDogs)
    }
}
