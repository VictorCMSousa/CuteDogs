//
//  CuteDogsListPresenter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import Foundation
import UIKit

protocol CuteDogsListPresenterRouter {
    
    func wantToShowDetails(of: CuteDog)
}

final class CuteDogsListPresenter {
    
    private let dogInteractor: DogBreedsInteractor
    private let imageLoaderInteractor: ImageLoaderInteractor
    private let router: CuteDogsListPresenterRouter
    private let pageSize: Int
    private var pageNumber: Int
    private var fetchedAll: Bool
    private var imagesTasks: [URL: Task<UIImage?, Never>] = [:]
    private var fetchedDogs: Set<CuteDog> = .init([])
    
    init(dogInteractor: DogBreedsInteractor,
         imageLoaderInteractor: ImageLoaderInteractor,
         router: CuteDogsListPresenterRouter,
         pageSize: Int,
         pageNumber: Int,
         fetchedAll: Bool) {
        
        self.dogInteractor = dogInteractor
        self.imageLoaderInteractor = imageLoaderInteractor
        self.router = router
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
                pageNumber += !fetchedAll ? 1 : 0
                fetchedDogs.formUnion(cuteDogsBreeds)
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
    
    func load(imageURL: URL, completion: @escaping (UIImage?) -> ()) {
        
        let imageTask = Task { () -> UIImage? in
            
            guard Task.isCancelled == false else { return nil }
                
            guard let imageData = try? await imageLoaderInteractor.fetchImage(imageURL: imageURL) else { return nil }
            let image = UIImage(data: imageData)
            guard Task.isCancelled == false else { return nil }
            return image
        }
        
        imagesTasks[imageURL] = imageTask
        Task {
            let image = await imageTask.value
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func cancelLoad(imageURL: URL) {
        imagesTasks[imageURL]?.cancel()
        imagesTasks[imageURL] = nil
    }
    
    func wantToShowDetails(id: String) {
        guard let selectedBreed = fetchedDogs.first(where: { $0.id == id }) else { return }
        router.wantToShowDetails(of: selectedBreed)
    }
}
