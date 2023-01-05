//
//  CuteDogLoaderCacheInteractorAdapter.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

final class CuteDogLoaderCacheInteractorAdapter: DogBreedsInteractor {
    
    private let remoteInteractor: DogBreedsInteractor
    private let cacheInteractor: DogBreedsCacheIntaractor?
    
    init(remoteInteractor: DogBreedsInteractor, cacheInteractor: DogBreedsCacheIntaractor?) {
        self.remoteInteractor = remoteInteractor
        self.cacheInteractor = cacheInteractor
    }
    
    func fetchMoreCuteDogs(offset: Int) async throws -> [CuteDog] {
        
        do {
            
            let cuteDogs = try await remoteInteractor.fetchMoreCuteDogs(offset: offset)
            await cacheInteractor?.save(cuteDogs: cuteDogs)
            return cuteDogs
        } catch {
            if offset > 0  { return [] }
            return await cacheInteractor?.fetchCuteDogs() ?? []
        }
    }
}
