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
    
    func test_fetchWeather_mapCuteDogs() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (.fiveBreeds, nil)

        let cuteDogs = try await sut.fetchBreeds(size: 5, pageNumber: 0)

        XCTAssertEqual(cuteDogs.count, 5)
        XCTAssertEqual(cuteDogs.first!.breedName, "Affenpinscher")
        XCTAssertEqual(cuteDogs.first!.origin, "Germany, France")
        XCTAssertEqual(cuteDogs.first!.breedGroup, "Toy")
        XCTAssertEqual(cuteDogs.first!.imageURL!.absoluteString, "https://cdn2.thedogapi.com/images/BJa4kxc4X.jpg")
    }
    
    func test_fetchWeather_decodeErrorOnEmptyData() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (Data(), nil)

        do {
            
            let _ = try await sut.fetchBreeds(size: 5, pageNumber: 0)
            XCTFail("Expecting failure")
        } catch let error as ApiError {
            XCTAssertEqual(error, .decodeError)
        }
    }
    
    func test_fetchWeather_apiErrorOnClient() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (Data(), ApiError.apiError)

        do {
            
            let _ = try await sut.fetchBreeds(size: 5, pageNumber: 0)
            XCTFail("Expecting failure")
        } catch let error as ApiError {
            XCTAssertEqual(error, .apiError)
        }
    }
    
    func makeSUT(client: HTTPClient = HTTPClientSpy(),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> DogBreedsInteractor {
        
        let sut = TheDogAPIInteractor(client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
