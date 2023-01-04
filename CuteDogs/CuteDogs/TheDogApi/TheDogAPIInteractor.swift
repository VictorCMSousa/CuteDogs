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
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("API_KEY config property is required") }
        return apiKey
    }
    
    private let pageSize: Int
    private var pageNumber: Int
    private var fetchedAll: Bool = false
    
    init(client: HTTPClient,
         pageSize: Int = 20,
         pageNumber: Int = 0) {
        
        self.client = client
        self.pageSize = pageSize
        self.pageNumber = pageNumber
    }
    
    func fetchMoreCuteDogs(offset: Int) async throws -> [CuteDog] {
        
        if offset > pageSize * pageNumber {
            pageNumber = offset / pageSize
        }
        guard !fetchedAll else {
            return []
        }
        let cuteDogs = try await fetchCuteDogs(size: pageSize, pageNumber: pageNumber)
        fetchedAll = cuteDogs.count < pageSize
        pageNumber += !fetchedAll ? 1 : 0
        return cuteDogs
    }
    
    private func fetchCuteDogs(size: Int, pageNumber: Int) async throws -> [CuteDog] {
        
        var componentURL = URLComponents(url: baseURL.appendingPathComponent("v1/breeds"),
                                         resolvingAgainstBaseURL: true)
        componentURL?.queryItems = [
            URLQueryItem(name: "limit", value: String(size)),
            URLQueryItem(name: "page", value: String(pageNumber))
        ]
        
        let dogBreeds: [DogBreed] = try await request(componentURL: componentURL)
        return dogBreeds.map{ $0.map() }
    }
    
    private func request<T: Decodable>(componentURL: URLComponents?) async throws -> T {
        
        guard let url = componentURL?.url else { throw ApiError.invalidURLFormat }
        let data = try await client.get(url: url)
        
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            throw ApiError.decodeError
        }
        return decoded
    }
}

private extension DogBreed {
    
    func map() -> CuteDog {
        .init(id: String(self.id),
              breedName: self.name,
              breedGroup: self.group ?? "",
              imageURL: URL(string: self.image?.url ?? ""),
              origin: self.origin ?? "Unknown",
              breedTemperament: self.temperament ?? "")
    }
}

// MARK: ImageLoaderInteractor

extension TheDogAPIInteractor: ImageLoaderInteractor {
    
    func fetchImage(imageURL: URL) async throws -> Data? {
        try await client.get(url: imageURL)
    }
}

// MARK: SeachDogBreedsInteractor

extension TheDogAPIInteractor: SearchDogBreedsInteractor {


    func searchCuteDogs(name: String) async throws -> [CuteDog] {
        
        var componentURL = URLComponents(url: baseURL.appendingPathComponent("v1/breeds/search"),
                                         resolvingAgainstBaseURL: true)
        
        componentURL?.queryItems = [URLQueryItem(name: "q", value: name)]
        let dogBreeds: [DogBreed] = try await request(componentURL: componentURL)
        return dogBreeds.map{ $0.map() }
    }
}
