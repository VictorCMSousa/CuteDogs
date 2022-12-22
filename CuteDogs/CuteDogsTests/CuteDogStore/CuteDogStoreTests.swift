//
//  CuteDogStoreTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

import XCTest
@testable import CuteDogs

final class CuteDogStoreTests: XCTestCase {
    
    func test_retrieve_returnEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        let retrievedResult = Result { try sut.retrieve() }
        
        switch retrievedResult {
        case .success(let cuteDogs):
            XCTAssertEqual(cuteDogs, [])
        default:
            XCTFail("Expecting success")
        }
    }
    
    func test_retrieve_returnCuteDogOnNonEmptyCache() {
        let sut = makeSUT()
        
        insert( [.anyDogBreed], to: sut)
        
        let retrievedResult = Result { try sut.retrieve() }
        
        switch retrievedResult {
        case .success(let cuteDogs):
            XCTAssertEqual(cuteDogs?.count, 1)
        default:
            XCTFail("Expecting success")
        }
    }
    
// MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CuteDogStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataCuteDogStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    @discardableResult
    func insert(_ cuteDogs: [CuteDog], to sut: CuteDogStore) -> Error? {
        do {
            try sut.insert(cuteDogs: cuteDogs)
            return nil
        } catch {
            return error
        }
    }
}
