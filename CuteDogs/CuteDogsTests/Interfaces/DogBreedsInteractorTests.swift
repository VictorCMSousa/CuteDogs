//
//  CuteDogsTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 16/12/2022.
//

import XCTest
@testable import CuteDogs

final class DogBreedsInteractorTests: XCTestCase {

    func test_fetchCuteDogs_validURL() async throws {
        
        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy, pageSize: 20, pageNumber: 0)
        clientSpy.getUrlStub = (Data(), nil)
        
        let _ = try? await sut.fetchMoreCuteDogs(offset: 0)
        
        XCTAssertEqual(clientSpy.getURLs.count, 1)
        
        let received = clientSpy.getURLs[0]
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "api.thedogapi.com", "host")
        XCTAssertEqual(received.path, "/v1/breeds", "path")
        XCTAssertEqual(received.query?.contains("page=0"), true, "pageNumber")
        XCTAssertEqual(received.query?.contains("limit=20"), true, "pageSize")
    }
    
    func test_fetchCuteDogs_withOffsetRecalculatePageNumber() async throws {
        
        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy, pageSize: 10, pageNumber: 0)
        clientSpy.getUrlStub = (Data(), nil)
        
        let _ = try? await sut.fetchMoreCuteDogs(offset: 20)
        
        XCTAssertEqual(clientSpy.getURLs.count, 1)
        
        let received = clientSpy.getURLs[0]
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "api.thedogapi.com", "host")
        XCTAssertEqual(received.path, "/v1/breeds", "path")
        XCTAssertEqual(received.query?.contains("page=2"), true, "pageNumber")
        XCTAssertEqual(received.query?.contains("limit=10"), true, "pageSize")
    }
    
    func test_fetchCuteDogs_mapCuteDogs() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (.fiveBreeds, nil)

        let cuteDogs = try await sut.fetchMoreCuteDogs(offset: 0)

        XCTAssertEqual(cuteDogs.count, 5)
        XCTAssertEqual(cuteDogs.first!.breedName, "Affenpinscher")
        XCTAssertEqual(cuteDogs.first!.origin, "Germany, France")
        XCTAssertEqual(cuteDogs.first!.breedGroup, "Toy")
        XCTAssertEqual(cuteDogs.first!.imageURL!.absoluteString, "https://cdn2.thedogapi.com/images/BJa4kxc4X.jpg")
    }
    
    func test_fetchCuteDogs_decodeErrorOnEmptyData() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (Data(), nil)

        do {
            
            let _ = try await sut.fetchMoreCuteDogs(offset: 0)
            XCTFail("Expecting failure")
        } catch let error as ApiError {
            XCTAssertEqual(error, .decodeError)
        }
    }
    
    func test_fetchCuteDogs_apiErrorOnClient() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (Data(), ApiError.apiError)

        do {
            
            let _ = try await sut.fetchMoreCuteDogs(offset: 0)
            XCTFail("Expecting failure")
        } catch let error as ApiError {
            XCTAssertEqual(error, .apiError)
        }
    }
    
    func test_fetchCuteDogs_fechedAllPreventRequest() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy, pageSize: 6, pageNumber: 0)
        clientSpy.getUrlStub = (.fiveBreeds, nil)
            
        let _ = try await sut.fetchMoreCuteDogs(offset: 0)
        let _ = try await sut.fetchMoreCuteDogs(offset: 0)
        
        XCTAssertEqual(clientSpy.getURLs.count, 1)
    }
    
    func test_fetchCuteDogs_responseSizeSmallerThanPageSizePreventRequest() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy, pageSize: 6, pageNumber: 0)
        clientSpy.getUrlStub = (.fiveBreeds, nil)
            
        let _ = try await sut.fetchMoreCuteDogs(offset: 0)
        let _ = try await sut.fetchMoreCuteDogs(offset: 0)
        
        XCTAssertEqual(clientSpy.getURLs.count, 1)
    }
    
    func test_fetchCuteDogs_increasePageNumber() async throws {
        
        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy, pageSize: 1, pageNumber: 0)
        clientSpy.getUrlStub = (.fiveBreeds, nil)
        
        let _ = try? await sut.fetchMoreCuteDogs(offset: 0)
        let _ = try? await sut.fetchMoreCuteDogs(offset: 0)
        
        XCTAssertEqual(clientSpy.getURLs.count, 2)
        
        let received = clientSpy.getURLs[1]
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "api.thedogapi.com", "host")
        XCTAssertEqual(received.path, "/v1/breeds", "path")
        XCTAssertEqual(received.query?.contains("page=1"), true, "pageNumber")
        XCTAssertEqual(received.query?.contains("limit=1"), true, "pageSize")
    }
    
    func makeSUT(client: HTTPClient = HTTPClientSpy(),
                 pageSize: Int = 20,
                 pageNumber: Int = 0,
                 file: StaticString = #filePath,
                 line: UInt = #line) -> DogBreedsInteractor {
        
        let sut = TheDogAPIInteractor(client: client, pageSize: pageSize, pageNumber: pageNumber)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
