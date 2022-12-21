//
//  SearchResultViewControllerPresenterTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

import XCTest
@testable import CuteDogs

final class SearchResultViewControllerPresenterTests: XCTestCase {
    
    func test_search_askForBreeds() {

        let searchInteractor = SearchDogBreedsInteractorSpy()
        let sut = makeSUT(searchInteractor: searchInteractor)
        let breedName = "Bull"
        let exp = expectation(description: "waiting completion")
        var capturedName = ""

        searchInteractor.searchCuteDogsAction = { name in
            capturedName = name
            return []
        }

        sut.search(breedName: breedName, completion: { _ in
            exp.fulfill()
        })


        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(capturedName, breedName)
    }

    func test_search_completionWithDogs() {

        let searchInteractor = SearchDogBreedsInteractorSpy()
        let sut = makeSUT(searchInteractor: searchInteractor)
        let exp = expectation(description: "waiting completion")
        let cuteDog = CuteDog.anyDogBreed

        var capturedResult: Result<[SearchCuteDogRowViewConfiguration], ApiError>? = nil
        searchInteractor.searchCuteDogsAction = { _ in
            return [cuteDog]
        }

        sut.search(breedName: "", completion: { result in
            capturedResult = result
            exp.fulfill()
        })

        wait(for: [exp], timeout: 0.1)

        switch capturedResult {
        case .success(let dogs):
            XCTAssertEqual(dogs, [.init(id: cuteDog.id,
                                        name: cuteDog.breedName,
                                        group: cuteDog.breedGroup,
                                        origin: cuteDog.origin)])
        default:
            XCTFail("Completion must succeeded")
        }
    }

    func test_search_completionWithError() {

        let searchInteractor = SearchDogBreedsInteractorSpy()
        let sut = makeSUT(searchInteractor: searchInteractor)
        let exp = expectation(description: "waiting completion")
        var capturedResult: Result<[SearchCuteDogRowViewConfiguration], ApiError>? = nil

        searchInteractor.searchCuteDogsAction = { _ in
            throw ApiError.apiError
        }

        sut.search(breedName: "",completion: { result in
            capturedResult = result
            exp.fulfill()
        })

        wait(for: [exp], timeout: 0.1)

        switch capturedResult {
        case .failure(let error):
            XCTAssertEqual(error, ApiError.apiError)
        default:
            XCTFail("Completion must fail")
        }
    }

    func test_wantToShowDetails_askRouterToShow() {
        
        let searchInteractor = SearchDogBreedsInteractorSpy()
        let router = SearchCuteDogsResultPresenterRouterSpy()
        let sut = makeSUT(searchInteractor: searchInteractor,
                          router: router)

        let exp = expectation(description: "waiting completion")

        searchInteractor.searchCuteDogsAction = { _ in
            return [.anyDogBreed]
        }

        sut.search(breedName: "", completion: { result in
            exp.fulfill()
        })

        wait(for: [exp], timeout: 0.1)
        sut.wantToShowDetails(id: CuteDog.anyDogBreed.id)
        XCTAssertEqual(router.wantToShowDetailsInput, [.anyDogBreed])

    }
    
    func makeSUT(searchInteractor: SearchDogBreedsInteractor = SearchDogBreedsInteractorSpy(),
                 router: SearchCuteDogsResultPresenterRouter = SearchCuteDogsResultPresenterRouterSpy(),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> SearchResultViewControllerPresenter {
        
        let sut = SearchCuteDogsResultPresenter(searchInteractor: searchInteractor, router: router)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
