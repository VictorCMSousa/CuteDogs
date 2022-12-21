//
//  SeachDogBreedsInteractor.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import Foundation

protocol SearchDogBreedsInteractor {
    
    func searchCuteDogs(name: String) async throws -> [CuteDog]
}
