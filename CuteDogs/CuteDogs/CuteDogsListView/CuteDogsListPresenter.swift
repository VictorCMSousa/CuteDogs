//
//  CuteDogsListPresenter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import Foundation

final class CuteDogsListPresenter {
    
    private let dogInteractor: DogBreedsInteractor
    private let pageSize: Int
    private var pageNumber: Int
    private var fetchedAll: Bool
    
    init(dogInteractor: DogBreedsInteractor, pageSize: Int, pageNumber: Int, fetchedAll: Bool) {
        
        self.dogInteractor = dogInteractor
        self.pageSize = pageSize
        self.pageNumber = pageNumber
        self.fetchedAll = fetchedAll
    }
}

extension CuteDogsListPresenter: CuteDogsListViewControllerPresenter {
    
    func loadMoreDogBreeds(completion: @escaping (Result<[CuteDogsCellConfiguration], ApiError>) -> ()) {
        
        guard !fetchedAll else {
            completion(.success([]))
            return
        }
        Task {
            do {
                let cuteDogsBreeds = try await dogInteractor.fetchBreeds(size: pageSize, pageNumber: pageNumber)
                fetchedAll = cuteDogsBreeds.count < pageSize
                pageNumber += 1
                let configs: [CuteDogsCellConfiguration] = cuteDogsBreeds.map(map)
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
    
    private func map(cuteDog: CuteDog) -> CuteDogsCellConfiguration {
        .init(id: cuteDog.id, name: cuteDog.breedName, dogImageURL: cuteDog.imageURL)
    }
}
