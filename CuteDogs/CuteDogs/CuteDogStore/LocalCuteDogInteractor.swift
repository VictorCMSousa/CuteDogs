//
//  LocalCuteDogInteractor.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import Foundation

protocol DogBreedsCacheIntaractor {
    func save(cuteDogs: [CuteDog]) async
    func fetchCuteDogs() async -> [CuteDog]
}

final class LocalCuteDogInteractor {
    private let store: CuteDogStore
    
    init?(store: CuteDogStore?) {
        guard let store else { return nil }
        self.store = store
    }
}

extension LocalCuteDogInteractor: DogBreedsCacheIntaractor {
    
    func save(cuteDogs: [CuteDog]) async {
        try? await store.insert(cuteDogs: cuteDogs)
    }
    
    func fetchCuteDogs() async -> [CuteDog] {
        let cuteDogs = try? await store.retrieve()?.map { map(localCuteDog: $0) }
        return cuteDogs ?? []
    }
    
    private func map(localCuteDog: CuteDogStored) -> CuteDog {
        .init(id: localCuteDog.id,
              breedName: localCuteDog.breedName,
              breedGroup: localCuteDog.breedGroup,
              imageURL: URL(string: localCuteDog.imageURL ?? ""),
              origin: localCuteDog.origin,
              breedTemperament: localCuteDog.breedTemperament)
        
    }
    
}
