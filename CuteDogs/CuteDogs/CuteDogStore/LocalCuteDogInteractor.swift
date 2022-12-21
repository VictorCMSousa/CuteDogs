//
//  LocalCuteDogInteractor.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import Foundation

protocol DogBreedsCacheIntaractor {
    func save(cuteDogs: [CuteDog])
    func fetchCuteDogs() -> [CuteDog]
}

final class LocalCuteDogInteractor {
    private let store: CuteDogStore
    
    init(store: CuteDogStore) {
        self.store = store
    }
}

extension LocalCuteDogInteractor: DogBreedsCacheIntaractor {
    
    
    func save(cuteDogs: [CuteDog]) {
        try? store.insert(cuteDogs: cuteDogs)
    }
    
    func fetchCuteDogs() -> [CuteDog] {
        let cuteDogs = try? store.retrieve()
        return cuteDogs ?? []
    }
}
