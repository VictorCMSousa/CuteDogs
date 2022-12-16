//
//  BreedsInteractor.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import Foundation

struct CuteDog {
    
    let breedName: String
    let breedGroup: String
    let imageURL: URL?
    let origin: String
    let breedTemperament: String
    
}

protocol DogBreedsInteractor {
    
    func fetchBreeds(size: Int, pageNumber: Int) async throws -> [CuteDog]
}
