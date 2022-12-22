//
//  CuteDogLoaderCacheInteractorAdapter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

final class CuteDogLoaderCacheInteractorAdapter: DogBreedsInteractor {
    
    let remoteInteractor: DogBreedsInteractor
    let cacheInteractor: DogBreedsCacheIntaractor?
    
    init(remoteInteractor: DogBreedsInteractor, cacheInteractor: DogBreedsCacheIntaractor?) {
        self.remoteInteractor = remoteInteractor
        self.cacheInteractor = cacheInteractor
    }
    
    func fetchCuteDogs(size: Int, pageNumber: Int) async throws -> [CuteDog] {
        
        do {
            
            let cuteDogs = try await remoteInteractor.fetchCuteDogs(size: size, pageNumber: pageNumber)
            cacheInteractor?.save(cuteDogs: cuteDogs)
            return cuteDogs
        } catch {
            if pageNumber > 0  { return [] }
            return cacheInteractor?.fetchCuteDogs() ?? []
        }
    }
}
