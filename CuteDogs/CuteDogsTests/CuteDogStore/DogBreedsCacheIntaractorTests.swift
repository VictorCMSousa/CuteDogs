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
        let sut = makeSUT()
        store.retrieveAction = { [] }
        
        let fetched = sut.fetchCuteDogs()
        
        XCTAssertEqual(fetched, [])
    }
    
    func test_fetchCuteDogs_returnEmptyCacheError() throws {
        
        let store = CuteDogStoreSpy()
        let sut = makeSUT()
        store.retrieveAction = { throw NSError(domain: "any", code: 0) }
            
        let fetched = sut.fetchCuteDogs()
        XCTAssertEqual(fetched, [])
        
    }
    
    private func makeSUT(store: CuteDogStore = CuteDogStoreSpy(),
                         file: StaticString = #filePath,
                         line: UInt = #line) -> DogBreedsCacheIntaractor {
        
        let sut = LocalCuteDogInteractor(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

final class CuteDogStoreSpy: CuteDogStore {
    
    var retrieveAction: () throws -> [CuteDog]? = { return nil }
    func retrieve() throws -> [CuteDog]? {
        try retrieveAction()
    }
    
    var insertedDogs = [CuteDog]()
    func insert(cuteDogs: [CuteDog]) throws {
        insertedDogs.append(contentsOf: cuteDogs)
    }
}
