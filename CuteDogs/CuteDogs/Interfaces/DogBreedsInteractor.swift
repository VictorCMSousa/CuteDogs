//
//  DogBreedsInteractor.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import Foundation

protocol DogBreedsInteractor {
    
    func fetchMoreCuteDogs(offset: Int) async throws -> [CuteDog]
}
