//
//  CuteDogsCellConfiguration.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

@testable import CuteDogs

extension CuteDogsCellConfiguration {
    
    static let anyDogs = CuteDogsCellConfiguration(id: "123",
                                                   name: "Any",
                                                   dogImageURL: .any)
    
    static let zAnotherDogs = CuteDogsCellConfiguration(id: "321",
                                                       name: "ZAnother",
                                                       dogImageURL: .any)
}
