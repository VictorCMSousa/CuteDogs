//
//  ImageLoaderInteractorTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 21/12/2022.
//

import XCTest
@testable import CuteDogs

final class ImageLoaderInteractorTests: XCTestCase {
    
    func test_fetchImage_validURL() async throws {
        
        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (Data(), nil)
        let url: URL = .any
        let _ = try? await sut.fetchImage(imageURL: url)
        
        XCTAssertEqual(clientSpy.getURLs.count, 1)
        
        let received = clientSpy.getURLs[0]
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "cdn2.thedogapi.com", "host")
        XCTAssertEqual(received.path, url.relativePath, "path")
    }
    
    func test_fetchImage_returnData() async throws {
        
        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        let data = UIImage(named: "cute-placehold")!.pngData()!
        clientSpy.getUrlStub = (data, nil)

        do {
            let receivedData = try await sut.fetchImage(imageURL: .any)
            XCTAssertEqual(receivedData, data)
        } catch {
            XCTFail("Expecting success")
        }
    }

    
    func test_fetchImage_apiErrorOnClient() async throws {

        let clientSpy = HTTPClientSpy()
        let sut = makeSUT(client: clientSpy)
        clientSpy.getUrlStub = (Data(), ApiError.apiError)

        do {
            let _ = try await sut.fetchImage(imageURL: .any)
            XCTFail("Expecting failure")
        } catch let error as ApiError {
            XCTAssertEqual(error, .apiError)
        }
    }
    
    func makeSUT(client: HTTPClient = HTTPClientSpy(),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> ImageLoaderInteractor {
        
        let sut = TheDogAPIInteractor(client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

