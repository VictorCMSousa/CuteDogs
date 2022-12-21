//
//  CuteDogDetailViewControllerTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

import XCTest
@testable import CuteDogs

final class CuteDogDetailViewControllerTests: XCTestCase {
    
    
    func test_viewLoad_updateLabels() {
        
        let presenter = CuteDogDetailViewControllerPresenterSpy()
        let sut = makeSUT(presenter: presenter)
        let config = CuteDogDetailViewConfiguration.any
        presenter.makerViewConfig = {
            config
        }

        sut.view.layoutIfNeeded()
        
        XCTAssertEqual(sut.breedNameLabel.text, config.name)
        XCTAssertEqual(sut.breedCategoryLabel.text, config.category)
        XCTAssertEqual(sut.breedOriginLabel.text, config.origin)
        XCTAssertEqual(sut.breedTemperamentLabel.text, config.temperament)
    }
    
    func test_viewLoadEmptyConfig_hideLabelsLabels() {
        
        let presenter = CuteDogDetailViewControllerPresenterSpy()
        let sut = makeSUT(presenter: presenter)
        let config = CuteDogDetailViewConfiguration.empty
        presenter.makerViewConfig = {
            config
        }

        sut.view.layoutIfNeeded()
        
        XCTAssertTrue(sut.categoryStackView.isHidden)
        XCTAssertTrue(sut.originStackView.isHidden)
        XCTAssertTrue(sut.temperamentStackView.isHidden)
    }
    
    func makeSUT(presenter: CuteDogDetailViewControllerPresenter = CuteDogDetailViewControllerPresenterSpy(),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> CuteDogDetailViewController {
        
        let sut = CuteDogDetailViewController(presenter: presenter)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
