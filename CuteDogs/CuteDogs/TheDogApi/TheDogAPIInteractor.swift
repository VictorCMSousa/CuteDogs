//
//  TheDogAPIInteractor.swift.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import Foundation

final class TheDogAPIInteractor: DogBreedsInteractor {
    
    private let baseURL = URL(string: "https://api.thedogapi.com")!
    private let client: HTTPClient
    private var apiKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("API_KEY config property is requered") }
        return apiKey
    }
    
    init(client: HTTPClient) {
        
        self.client = client
    }
    
    func fetchBreeds(size: Int, pageNumber: Int) async throws -> [CuteDog] {
        
        var componentURL = URLComponents(url: baseURL.appendingPathComponent("v1/breeds"),
                                         resolvingAgainstBaseURL: true)
        componentURL?.queryItems = [
            URLQueryItem(name: "limit", value: String(size)),
            URLQueryItem(name: "page", value: String(pageNumber))
        ]
        
        guard let breedsUrlRequest = componentURL?.url else { throw ApiError.invalidURLFormat }
        let data = try await client.get(url: breedsUrlRequest)
        guard let dogBreeds = try? JSONDecoder().decode([DogBreed].self, from: data) else {
            throw ApiError.decodeError
        }
        return dogBreeds.map{ $0.map() }
    }
}

extension DogBreed {
    
    func map() -> CuteDog {
        .init(breedName: self.name,
              breedGroup: self.group ?? "",
              imageURL: URL(string: self.image.url),
              origin: self.origin ?? "Unknown",
              breedTemperament: self.temperament ?? "")
    }
}
