//
//  SearchCuteDogsResultPresenter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import Foundation

protocol SearchCuteDogsResultPresenterRouter {
    
    func wantToShowDetails(of: CuteDog)
}

final class SearchCuteDogsResultPresenter: SearchResultViewControllerPresenter {
    
    private let searchInteractor: SearchDogBreedsInteractor
    private let router: SearchCuteDogsResultPresenterRouter
    private var cuteDogs = [CuteDog]()
    
    init(searchInteractor: SearchDogBreedsInteractor, router: SearchCuteDogsResultPresenterRouter) {
        self.searchInteractor = searchInteractor
        self.router = router
    }
    
    func search(breedName: String, completion: @escaping (Result<[SearchCuteDogRowViewConfiguration], ApiError>) -> ()) {
        
        Task {
            do {
                let cuteDogsBreeds = try await searchInteractor.searchCuteDogs(name: breedName)
                cuteDogs = cuteDogsBreeds
                let configs: [SearchCuteDogRowViewConfiguration] = cuteDogsBreeds.map(map)
                DispatchQueue.main.async {
                    completion(.success(configs))
                }
            } catch let error as ApiError {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func map(cuteDog: CuteDog) -> SearchCuteDogRowViewConfiguration {
        .init(id: cuteDog.id, name: cuteDog.breedName, group: cuteDog.breedGroup, origin: cuteDog.origin)
    }
    
    func wantToShowDetails(id: String) {
        guard let cuteDog = cuteDogs.first(where: { $0.id == id }) else { return }
        router.wantToShowDetails(of: cuteDog)
    }
    
}
