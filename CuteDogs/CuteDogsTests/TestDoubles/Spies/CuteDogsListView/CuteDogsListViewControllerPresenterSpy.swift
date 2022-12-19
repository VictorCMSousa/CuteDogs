//
//  CuteDogsListViewControllerPresenterSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

import UIKit
@testable import CuteDogs

final class CuteDogsListViewControllerPresenterSpy: CuteDogsListViewControllerPresenter {
    
    var wantToShowDetailsIds = [String]()
    func wantToShowDetails(id: String) {
        wantToShowDetailsIds.append(id)
    }
    
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
