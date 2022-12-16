//
//  HTTPClientSpy.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 16/12/2022.
//

import Foundation
@testable import CuteDogs

final class HTTPClientSpy: HTTPClient {
    
    var getURLs = [URL]()
    
    var getUrlStub: (data: Data, error: Error?) = (Data(), nil)
    func get(url: URL) async throws -> Data {
        getURLs.append(url)
        if let error = getUrlStub.error {
            throw error
        }
        return getUrlStub.data
    }
}
