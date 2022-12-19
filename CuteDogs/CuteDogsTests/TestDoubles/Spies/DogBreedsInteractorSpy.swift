//
//  DogBreedsInteractorSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

import Foundation
@testable import CuteDogs

final class DogBreedsInteractorSpy: DogBreedsInteractor {
    
    var fetchBreedsAction: (Int, Int) throws -> ([CuteDog]) = { _,_ in return []}

    func fetchBreeds(size: Int, pageNumber: Int) async throws -> [CuteDog] {
        try fetchBreedsAction(size, pageNumber)
    }
}
