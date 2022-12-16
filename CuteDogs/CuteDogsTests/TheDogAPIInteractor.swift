//
//  CuteDogsTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 16/12/2022.
//

import XCTest
@testable import CuteDogs

final class TheDogAPIInteractorTests: XCTestCase {

    func test_fetchWeather_validURL() async throws {
        
        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (Data(), nil)
        
        let _ = try? await sut.fetchBreeds(size: 0, pageNumber: 0)
        
        XCTAssertEqual(clientSpy.getURLs.count, 1)
        
        let received = clientSpy.getURLs[0]
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "api.thedogapi.com", "host")
        XCTAssertEqual(received.path, "/v1/breeds", "path")
        XCTAssertEqual(received.query?.contains("page=0"), true, "pageNumber")
        XCTAssertEqual(received.query?.contains("limit=0"), true, "pageSize")
    }
    
    func makeSUT(client: HTTPClient = HTTPClientSpy(),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> BreedsInteractor {
        
        let sut = TheDogAPIInteractor(client: client)
        return sut
    }
}
