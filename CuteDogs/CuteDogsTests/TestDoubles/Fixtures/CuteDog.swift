//
//  CuteDog.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 19/12/2022.
//

import Foundation
@testable import CuteDogs

extension CuteDog {
    
    static let anyDogBreed = CuteDog(id: "123",
                                      breedName: "any dog",
                                      breedGroup: "any",
                                      imageURL: URL(string: "https://cdn2.thedogapi.com/images/B12BnxcVQ.jpg"),
                                      origin: "any",
                                      breedTemperament: "Any")
    
}
