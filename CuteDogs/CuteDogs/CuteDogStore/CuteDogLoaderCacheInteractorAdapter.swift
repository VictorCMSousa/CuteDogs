//
//  CuteDogLoaderCacheInteractorAdapter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

final class CuteDogLoaderCacheInteractorAdapter: DogBreedsInteractor {
    
    let remoteLoader: DogBreedsInteractor
    let storeInteractor: DogBreedsCacheIntaractor
    
    init(remoteLoader: DogBreedsInteractor, storeInteractor: DogBreedsCacheIntaractor) {
        self.remoteLoader = remoteLoader
        self.storeInteractor = storeInteractor
    }
    
    func fetchCuteDogs(size: Int, pageNumber: Int) async throws -> [CuteDog] {
        
        do {
            
            let cuteDogs = try await remoteLoader.fetchCuteDogs(size: size, pageNumber: pageNumber)
            try? storeInteractor.save(cuteDogs: cuteDogs)
            return cuteDogs
        } catch {
            if pageNumber > 0  { return [] }
            return try storeInteractor.fetchCuteDogs()
        }
    }
}
