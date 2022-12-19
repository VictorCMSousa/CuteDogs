//
//  CuteDogsListViewControllerTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

import XCTest
@testable import CuteDogs

final class CuteDogsListViewControllerTests: XCTestCase {
    
    func test_loadView_askForMoreDogBreeds() {
        
        let presenter = CuteDogsListViewControllerPresenterSpy()
        let sut = makeSUT(presenter: presenter)
        sut.view.layoutIfNeeded()
        
        XCTAssertEqual(presenter.loadMoreDogBreedsCompletion.count, 1)
    }
    
    func test_loadView_displayBreedsAfterCompletion() {
        
        let presenter = CuteDogsListViewControllerPresenterSpy()
        let sut = makeSUT(presenter: presenter)
        
        loadView(dogsConfig: [.anyDogs, .zAnotherDogs], presenter: presenter, sut: sut)
        
        XCTAssertEqual(sut.collectionView.numberOfSections, 1)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 2)
    }
    
    func test_loadView_startListMode() {
        
        let presenter = CuteDogsListViewControllerPresenterSpy()
        let sut = makeSUT(presenter: presenter)
        loadView(dogsConfig: [.anyDogs, .zAnotherDogs], presenter: presenter, sut: sut)
        
        let cell = sut.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CuteDogsListCellView
        
        XCTAssertNotNil(cell)
    }
    
    func test_onToggleStyle_changeToGrid() {
        
        let presenter = CuteDogsListViewControllerPresenterSpy()
        let sut = makeSUT(presenter: presenter)
        loadView(dogsConfig: [.anyDogs, .zAnotherDogs], presenter: presenter, sut: sut)

        sut.onStyleToggle("")
        sut.view.layoutIfNeeded()
        
        let cell = sut.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CuteDogsGridCellView
        XCTAssertNotNil(cell)
    }
    
    func test_onSortButton_sortCells() {
        
        let presenter = CuteDogsListViewControllerPresenterSpy()
        let sut = makeSUT(presenter: presenter)
        loadView(dogsConfig: [.zAnotherDogs, .anyDogs], presenter: presenter, sut: sut)
        
        let initialFirst = sut.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CuteDogsListCellView
        let initialSecond = sut.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? CuteDogsListCellView
        
        sut.onSortButton("")
        sut.view.layoutIfNeeded()
        
        let afterSortFirst = sut.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CuteDogsListCellView
        let afterSortSecond = sut.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? CuteDogsListCellView
        
        XCTAssertEqual(initialFirst?.nameLabel.text, afterSortSecond?.nameLabel.text)
        XCTAssertEqual(initialSecond?.nameLabel.text, afterSortFirst?.nameLabel.text)
    }
    
    func test_willDisplay_askForBreedsImage() {
        
        let presenter = CuteDogsListViewControllerPresenterSpy()
        let sut = makeSUT(presenter: presenter)
        loadView(dogsConfig: [.anyDogs], presenter: presenter, sut: sut)
        
        XCTAssertEqual(presenter.askedURLs, [CuteDogsCellConfiguration.anyDogs.dogImageURL])
    }
    
    func test_willDisplay_showMoreItemsAfterCompletion() {
        
        let presenter = CuteDogsListViewControllerPresenterSpy()
        let sut = makeSUT(presenter: presenter)
        loadView(dogsConfig: [.anyDogs], presenter: presenter, sut: sut)
        let indexPath = IndexPath(item: 0, section: 0)
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 1)
        
        let cell = sut.collectionView.cellForItem(at:indexPath)!
        // loadMoreDogBreedsCompletion[1] because loadView request presenter first
        presenter.loadMoreDogBreedsCompletion[1]((.success([.zAnotherDogs])))
        sut.collectionView(sut.collectionView,
                           willDisplay: cell,
                           forItemAt: indexPath)
        sut.view.layoutIfNeeded()
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 2)
    }
    
    func test_didEndDisplaying_cancelLoad() {
        
        let presenter = CuteDogsListViewControllerPresenterSpy()
        let sut = makeSUT(presenter: presenter)
        loadView(dogsConfig: [.anyDogs], presenter: presenter, sut: sut)
        let indexPath = IndexPath(item: 0, section: 0)
        
        let cell = sut.collectionView.cellForItem(at:indexPath)!
        
        sut.collectionView(sut.collectionView, didEndDisplaying: cell, forItemAt: indexPath)
        
        XCTAssertEqual(presenter.cancelLoadURLs, [CuteDogsCellConfiguration.anyDogs.dogImageURL])
    }
    
    func makeSUT(presenter: CuteDogsListViewControllerPresenter = CuteDogsListViewControllerPresenterSpy(),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> CuteDogsListViewController {
        
        let sut = CuteDogsListViewController(presenter: presenter)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
// MARK: HELPERS
    
    func loadView(dogsConfig: [CuteDogsCellConfiguration],
                  presenter: CuteDogsListViewControllerPresenterSpy,
                  sut: CuteDogsListViewController) {
        
        sut.view.layoutIfNeeded()
        
        presenter.loadMoreDogBreedsCompletion[0](.success(dogsConfig))
    }
}

final class CuteDogsListViewControllerPresenterSpy: CuteDogsListViewControllerPresenter {
    
    var loadMoreDogBreedsCompletion = [(Result<[CuteDogsCellConfiguration], CuteDogs.ApiError>) -> ()]()
    func loadMoreDogBreeds(completion: @escaping (Result<[CuteDogsCellConfiguration], ApiError>) -> ()) {
        loadMoreDogBreedsCompletion.append(completion)
    }
    
    var askedURLs = [URL]()
    var loadImageURLCompletion = [(UIImage?) -> ()]()
    func load(imageURL: URL, completion: @escaping (UIImage?) -> ()) {
        askedURLs.append(imageURL)
        loadImageURLCompletion.append(completion)
    }
    var cancelLoadURLs = [URL]()
    func cancelLoad(imageURL: URL) {
        cancelLoadURLs.append(imageURL)
    }
}

extension CuteDogsCellConfiguration {
    
    static let anyDogs = CuteDogsCellConfiguration(id: "123",
                                                   name: "Any",
                                                   dogImageURL: .any)
    
    static let zAnotherDogs = CuteDogsCellConfiguration(id: "321",
                                                       name: "ZAnother",
                                                       dogImageURL: .any)
}
