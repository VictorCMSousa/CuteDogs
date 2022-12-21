//
//  SeachDogBreedsInteractor.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import Foundation

protocol SeachDogBreedsInteractor {
    
    func searchCuteDogs(name: String) async throws -> [CuteDog]
}
