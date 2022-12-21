//
//  Infra.swift
//  CuteDogs
//
//  Created by Victor Sousa on 16/12/2022.
//

import Foundation


protocol AppSession {
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: AppSession { }

protocol HTTPClient {
    
    func get(url: URL) async throws -> Data
}

enum ApiError: String, Error {
    
    case invalidResponse
    case decodeError
    case apiError
    case invalidURLFormat
    
    var description: String {
        
        switch self {
        case .apiError: return "Ops! Api Error"
        case .invalidURLFormat: return "Ops! Invalid URL formart"
        case .decodeError: return "Ops! Somethig change, decode error"
        case .invalidResponse: return "Ops! Invalid response"
        }
    }
}

final class NetworkClient: HTTPClient {
    
    private let session: AppSession
    
    init(session: AppSession) {
        self.session = session
    }
    
    func get(url: URL) async throws -> Data {
        
        do {
            let (data, response) = try await session.data(from: url, delegate: nil)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                throw ApiError.invalidResponse
            }
            return data
        } catch {
            throw ApiError.apiError
        }
    }
}
