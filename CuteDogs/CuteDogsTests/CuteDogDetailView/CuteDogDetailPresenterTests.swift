//
//  CuteDogDetailPresenterTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

import XCTest
@testable import CuteDogs

final class CuteDogDetailPresenterTests: XCTestCase {
    
    func test_makeViewConfig_returnViewConfig() {
        
        let cuteDog = CuteDog.anyDogBreed
        let sut = makeSUT(cuteDog: cuteDog)
        
        let config = sut.makeViewConfig()
        
        XCTAssertEqual(config.name, cuteDog.breedName)
        XCTAssertEqual(config.category, cuteDog.breedGroup)
        XCTAssertEqual(config.origin, cuteDog.origin)
        XCTAssertEqual(config.temperament, cuteDog.breedTemperament)
        
    }
    
    func makeSUT(cuteDog: CuteDog,
                 file: StaticString = #filePath,
                 line: UInt = #line) -> CuteDogDetailViewControllerPresenter {
        
        let sut = CuteDogDetailPresenter(cuteDog: cuteDog)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
