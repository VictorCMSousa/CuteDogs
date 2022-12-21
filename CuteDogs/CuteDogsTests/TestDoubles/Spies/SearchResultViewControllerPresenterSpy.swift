//
//  SearchResultViewControllerPresenterSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

@testable import CuteDogs

final class SearchResultViewControllerPresenterSpy: SearchResultViewControllerPresenter {
    
    var breedNames = [String]()
    var searchBreedsCompletion = [(Result<[SearchCuteDogRowViewConfiguration], ApiError>) -> ()]()
    
    func search(breedName: String, completion: @escaping (Result<[SearchCuteDogRowViewConfiguration], ApiError>) -> ()) {
        breedNames.append(breedName)
        searchBreedsCompletion.append(completion)
    }
    
    var wantToShowDetailsIds = [String]()
    func wantToShowDetails(id: String) {
        wantToShowDetailsIds.append(id)
    }
}
