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
    let group: String?
    let lifeSpan: String
    let temperament, origin: String?
    let referenceImageID: String
    let image: DogImage
    let description, history: String?

    enum CodingKeys: String, CodingKey {
        case weight, height, id, name, description
        case bredFor = "bred_for"
        case group = "breed_group"
        case lifeSpan = "life_span"
        case temperament, origin
        case referenceImageID = "reference_image_id"
        case image
        case history
    }
}

struct DogMeasureRange: Codable {
    let imperial, metric: String
}

struct DogImage: Codable {
    let id: String
    let width, height: Int
    let url: String
}

