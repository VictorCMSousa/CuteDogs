//
//  CuteDogStoreTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

import XCTest
@testable import CuteDogs

final class CuteDogStoreTests: XCTestCase {
    
    func test_retrieve_returnEmptyOnEmptyCache() async throws {
        let sut = makeSUT()
        
        let cuteDogs = try await sut.retrieve()
        
        XCTAssertEqual(cuteDogs, [])
    }
    
    func test_retrieve_returnCuteDogOnNonEmptyCache() async throws {
        let sut = makeSUT()
        
        await insert( [.anyDogBreed], to: sut)
        
        let cuteDogs = try await sut.retrieve()
        
        XCTAssertEqual(cuteDogs?.count, 1)
    }
    
// MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CuteDogStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataCuteDogStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    @discardableResult
    func insert(_ cuteDogs: [CuteDog], to sut: CuteDogStore) async -> Error? {
        do {
            try await sut.insert(cuteDogs: cuteDogs)
            return nil
        } catch {
            return error
        }
    }
}
