//
//  SeachDogBreedsInteractorSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

@testable import CuteDogs

final class SeachDogBreedsInteractorSpy: SeachDogBreedsInteractor {
    
    var searchCuteDogsAction: (String) throws -> ([CuteDog]) = { _ in return []}
    func searchCuteDogs(name: String) async throws -> [CuteDog] {
        
        try searchCuteDogsAction(name)
    }
}
