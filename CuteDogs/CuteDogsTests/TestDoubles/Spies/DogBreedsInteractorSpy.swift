//
//  DogBreedsInteractorSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

import Foundation
@testable import CuteDogs

final class DogBreedsInteractorSpy: DogBreedsInteractor {
    
    var fetchMoreCuteDogsAction: (Int) throws -> ([CuteDog]) = { _ in return []}

    func fetchMoreCuteDogs(offset: Int) async throws -> [CuteDog] {
        try fetchMoreCuteDogsAction(offset)
    }
}
