//
//  SearchCuteDogViewControllerTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

import XCTest
@testable import CuteDogs

final class SearchCuteDogViewControllerTests: XCTestCase {
    
    func test_search_askCuteDogs() {
        
        let presenter = SearchResultViewControllerPresenterSpy()
        let searchController = UISearchController(searchResultsController: nil)
        let sut = makeSUT(presenter: presenter, searchController: searchController)
        searchController.searchBar.text = "Bull"
        let exp = expectation(description: "waiting to perform request")
        
        sut.updateSearchResults(for: searchController)
        
        DispatchQueue.global().asyncAfter(deadline: .now().advanced(by: .milliseconds(100)),
                                          execute: { exp.fulfill() })
        
        wait(for: [exp], timeout: 0.2)

        
        XCTAssertEqual(presenter.breedNames, ["Bull"])
    }
    
    func test_search_showDogsAfterCompletion() {
        
        let presenter = SearchResultViewControllerPresenterSpy()
        let searchController = UISearchController(searchResultsController: nil)
        let sut = makeSUT(presenter: presenter, searchController: searchController)
        searchController.searchBar.text = "Bull"
        let config = SeachCuteDogRowViewConfiguration.any
        search(searchController: searchController, sut: sut)

        loadView(with: [config],
                 presenter: presenter,
                 sut: sut)
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
        let cell = sut.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SearchCuteDogRowView
        XCTAssertEqual(cell.nameLabel.text, config.name)
        XCTAssertEqual(cell.categoryLabel.text, config.group)
        XCTAssertEqual(cell.originLabel.text, config.origin)
    }
    
    func test_didSelectRow_wantToShowDetail() {
        
        let presenter = SearchResultViewControllerPresenterSpy()
        let searchController = UISearchController(searchResultsController: nil)
        let sut = makeSUT(presenter: presenter, searchController: searchController)
        searchController.searchBar.text = "Bull"
        let config = SeachCuteDogRowViewConfiguration.any
        search(searchController: searchController, sut: sut)

        loadView(with: [config],
                 presenter: presenter,
                 sut: sut)
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(presenter.wantToShowDetailsIds, [config.id])
    }
    
    // MARK: HELPERS
    func makeSUT(presenter: SearchResultViewControllerPresenter = SearchResultViewControllerPresenterSpy(),
                 searchController: UISearchController =  UISearchController(searchResultsController: nil),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> SearchCuteDogViewController {
        
        let sut = SearchCuteDogViewController(presenter: presenter,
                                              searchController: searchController,
                                              waitingToRequest: 0)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    func search(searchController: UISearchController, sut: SearchCuteDogViewController) {
        
        searchController.searchBar.text = "Bull"
        let exp = expectation(description: "waiting to perform request")
        
        sut.updateSearchResults(for: searchController)
        
        DispatchQueue.global().asyncAfter(deadline: .now().advanced(by: .milliseconds(100)),
                                          execute: { exp.fulfill() })
        
        wait(for: [exp], timeout: 0.2)
    }
        
    func loadView(with config: [SeachCuteDogRowViewConfiguration],
                  presenter: SearchResultViewControllerPresenterSpy,
                  sut: SearchCuteDogViewController) {
        
        sut.view.layoutIfNeeded()
        
        presenter.searchBreedsCompletion[0](.success(config))
    }
}
