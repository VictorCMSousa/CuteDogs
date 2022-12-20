//
//  ImageCacheTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 20/12/2022.
//

import XCTest
@testable import CuteDogs

final class ImageCacheTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_fetchImageEmptyStore_returnNil() async {
        
        let sut = makeSUT()
        
        let empty = try? await sut.fetchImage(imageURL: testSpecificImageURL())
        
        XCTAssertNil(empty)
    }
    
    func test_saveThenFetch_returnData() async {
        
        let sut = makeSUT()
        let anyData = Data()
        
        sut.save(anyData, for: testSpecificImageURL())
        let fetched = try? await sut.fetchImage(imageURL: testSpecificImageURL())
        
        XCTAssertEqual(anyData, fetched)
    }
    
    func test_saveThenFetchTwice_returnSameData() async {
        
        let sut = makeSUT()
        let anyData = Data()
        
        sut.save(anyData, for: testSpecificImageURL())
        let fetched = try? await sut.fetchImage(imageURL: testSpecificImageURL())
        let fetchedAgain = try? await sut.fetchImage(imageURL: testSpecificImageURL())
        
        XCTAssertEqual(anyData, fetched)
        XCTAssertEqual(anyData, fetchedAgain)
    }
    
    func test_saveTwice_updateCache() async {
        
        let sut = makeSUT()
        let anyData = Data()
        let anotherData = UIImage(named: "cute-placehold")!.pngData()!
        
        sut.save(anyData, for: testSpecificImageURL())
        sut.save(anotherData, for: testSpecificImageURL())
        let fetched = try? await sut.fetchImage(imageURL: testSpecificImageURL())
        
        XCTAssertEqual(anotherData, fetched)
    }
    
    func test_saveInvalidURL_returnNil() async {
        
        let sut = makeSUT()
        let anyData = Data()
        let invalidFileName = URL(string: "//")!
        
        sut.save(anyData, for: invalidFileName)
        let empty = try? await sut.fetchImage(imageURL: invalidFileName)
        
        XCTAssertNil(empty)
    }
    
    func makeSUT(file: StaticString = #filePath,
                 line: UInt = #line) -> ImageCacheLoaderInteractor {
        
        let sut = ImageCacheLoader(baseDirectory: .cachesDirectory)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificImageURL())
    }
    
    private func testSpecificImageURL() -> URL {
        return cachesDirectory().appendingPathComponent("someImage.jpg")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
