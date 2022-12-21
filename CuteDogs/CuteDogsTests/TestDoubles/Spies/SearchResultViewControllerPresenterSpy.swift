//
//  SearchResultViewControllerPresenterSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

@testable import CuteDogs

final class SearchResultViewControllerPresenterSpy: SearchResultViewControllerPresenter {
    
    var breedNames = [String]()
    var searchBreedsCompletion = [(Result<[SeachCuteDogRowViewConfiguration], ApiError>) -> ()]()
    
    func search(breedName: String, completion: @escaping (Result<[SeachCuteDogRowViewConfiguration], ApiError>) -> ()) {
        breedNames.append(breedName)
        searchBreedsCompletion.append(completion)
    }
    
    var wantToShowDetailsIds = [String]()
    func wantToShowDetails(id: String) {
        wantToShowDetailsIds.append(id)
    }
}
