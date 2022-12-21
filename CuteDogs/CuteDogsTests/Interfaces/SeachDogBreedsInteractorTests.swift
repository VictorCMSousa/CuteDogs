//
//  SeachDogBreedsInteractorTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

import XCTest
@testable import CuteDogs

final class SeachDogBreedsInteractorTests: XCTestCase {

    func test_searchCuteDogs_validURL() async throws {
        
        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (Data(), nil)
        let breedName = "Bull"
        
        let _ = try? await sut.searchCuteDogs(name: breedName)
        
        XCTAssertEqual(clientSpy.getURLs.count, 1)
        
        let received = clientSpy.getURLs[0]
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "api.thedogapi.com", "host")
        XCTAssertEqual(received.path, "/v1/breeds", "path")
        XCTAssertEqual(received.query?.contains("q=\(breedName)"), true, "breeed name")
    }

    func test_searchCuteDogs_mapCuteDogs() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (.fiveBreeds, nil)
        let breedName = "Bull"
        
        let cuteDogs = try await sut.searchCuteDogs(name: breedName)

        XCTAssertEqual(cuteDogs.count, 5)
        XCTAssertEqual(cuteDogs.first!.breedName, "Affenpinscher")
        XCTAssertEqual(cuteDogs.first!.origin, "Germany, France")
        XCTAssertEqual(cuteDogs.first!.breedGroup, "Toy")
        XCTAssertEqual(cuteDogs.first!.imageURL!.absoluteString, "https://cdn2.thedogapi.com/images/BJa4kxc4X.jpg")
    }

    func test_searchCuteDogs_decodeErrorOnEmptyData() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (Data(), nil)
        let breedName = "Bull"
        
        do {

            let _ = try await sut.searchCuteDogs(name: breedName)
            XCTFail("Expecting failure")
        } catch let error as ApiError {
            XCTAssertEqual(error, .decodeError)
        }
    }

    func test_searchCuteDogs_apiErrorOnClient() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (Data(), ApiError.apiError)
        let breedName = "Bull"
        
        do {

            let _ = try await sut.searchCuteDogs(name: breedName)
            XCTFail("Expecting failure")
        } catch let error as ApiError {
            XCTAssertEqual(error, .apiError)
        }
    }
    
    func makeSUT(client: HTTPClient = HTTPClientSpy(),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> SeachDogBreedsInteractor {
        
        let sut = TheDogAPIInteractor(client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

