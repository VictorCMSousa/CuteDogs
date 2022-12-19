//
//  CuteDogDetailViewConfiguration.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

@testable import CuteDogs

extension CuteDogDetailViewConfiguration {
    
    static let any = CuteDogDetailViewConfiguration(name: "any", category: "category", origin: "origin", temperament: "temperament")
    
    static let empty = CuteDogDetailViewConfiguration(name: "empty", category: "", origin: "", temperament: "")
}
