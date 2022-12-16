//
//  DogsBreeds.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import Foundation

struct DogBreed: Codable {
    let weight, height: DogMeasureRange
    let id: Int
    let name: String
    let bredFor: String?
    let breedGroup: BreedGroup?
    let lifeSpan: String
    let temperament, origin: String?
    let referenceImageID: String
    let image: DogImage
    let welcomeDescription, history: String?

    enum CodingKeys: String, CodingKey {
        case weight, height, id, name
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case lifeSpan = "life_span"
        case temperament, origin
        case referenceImageID = "reference_image_id"
        case image
        case welcomeDescription = "description"
        case history
    }
}

enum BreedGroup: String, Codable {
    case empty = ""
    case herding = "Herding"
    case hound = "Hound"
    case mixed = "Mixed"
    case nonSporting = "Non-Sporting"
    case sporting = "Sporting"
    case terrier = "Terrier"
    case toy = "Toy"
    case working = "Working"
}

struct DogMeasureRange: Codable {
    let imperial, metric: String
}

struct DogImage: Codable {
    let id: String
    let width, height: Int
    let url: String
}

