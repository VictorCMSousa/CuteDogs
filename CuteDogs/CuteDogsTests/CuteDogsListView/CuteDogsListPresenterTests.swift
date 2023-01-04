//
//  CuteDogsListPresenterTests.swift
//  CuteDogsTests
//
//  Created by Victor Sousa on 18/12/2022.
//

import XCTest
@testable import CuteDogs

final class CuteDogsListPresenterTests: XCTestCase {
    
    func test_loadMoreDogsBreed_askForBreeds() {

        let dogInteractor = DogBreedsInteractorSpy()
        let sut = makeSUT(dogInteractor: dogInteractor)
        let exp = expectation(description: "waiting completion")
        var capturedOffset = 0

        dogInteractor.fetchMoreCuteDogsAction = { offset in
            capturedOffset = offset
            return []
        }

        sut.loadMoreDogBreeds(completion: { _ in
            exp.fulfill()
        })


        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(capturedOffset, 0)
    }

    func test_loadMoreDogsBreed_completionWithDogs() {

        let dogInteractor = DogBreedsInteractorSpy()
        let sut = makeSUT(dogInteractor: dogInteractor)
        let exp = expectation(description: "waiting completion")
        let cuteDog = CuteDog.anyDogBreed

        var capturedResult: Result<[CuteDogsCellConfiguration], ApiError>? = nil
        dogInteractor.fetchMoreCuteDogsAction = { _ in
            return [cuteDog]
        }

        sut.loadMoreDogBreeds(completion: { result in
            capturedResult = result
            exp.fulfill()
        })

        wait(for: [exp], timeout: 0.1)

        switch capturedResult {
        case .success(let dogs):
            XCTAssertEqual(dogs, [.init(id: cuteDog.id,
                                        name: cuteDog.breedName,
                                        dogImageURL: cuteDog.imageURL)])
        default:
            XCTFail("Completion must succeeded")
        }
    }

    func test_loadMoreDogsBreed_completionWithError() {

        let dogInteractor = DogBreedsInteractorSpy()
        let sut = makeSUT(dogInteractor: dogInteractor)
        let exp = expectation(description: "waiting completion")
        var capturedResult: Result<[CuteDogsCellConfiguration], ApiError>? = nil

        dogInteractor.fetchMoreCuteDogsAction = { _ in
            throw ApiError.apiError
        }

        sut.loadMoreDogBreeds(completion: { result in
            capturedResult = result
            exp.fulfill()
        })

        wait(for: [exp], timeout: 0.1)

        switch capturedResult {
        case .failure(let error):
            XCTAssertEqual(error, ApiError.apiError)
        default:
            XCTFail("Completion must fail")
        }
    }

    func test_loadImageURL_askForImageURL() {
        
        let imageLoaderInteractor = ImageLoaderInteractorSpy()
        let sut = makeSUT(imageLoaderInteractor: imageLoaderInteractor)
        let exp = expectation(description: "waiting completion")
        var capturedURL: URL? = nil
        
        imageLoaderInteractor.fetchImageAction = { url in
            capturedURL = url
            return Data()
        }
        
        sut.load(imageURL: .any) { _ in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(capturedURL, .any)
    }
    
    func test_loadImageURL_completionWithImage() {
        
        let imageLoaderInteractor = ImageLoaderInteractorSpy()
        let sut = makeSUT(imageLoaderInteractor: imageLoaderInteractor)
        let exp = expectation(description: "waiting completion")
        let image = UIImage(systemName: "chevron.up")!
        var capturedImage: UIImage?
        imageLoaderInteractor.fetchImageAction = { _ in
            image.jpegData(compressionQuality: 1)
        }
        
        sut.load(imageURL: .any) { image in
            capturedImage = image
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertNotNil(capturedImage)
    }
    
    func test_loadImageURL_cancelLoadCompletionWithNil() {
        
        let imageLoaderInteractor = ImageLoaderInteractorSpy()
        let sut = makeSUT(imageLoaderInteractor: imageLoaderInteractor)
        let exp = expectation(description: "waiting completion")
        var capturedImage: UIImage?
                
        sut.load(imageURL: .any) { image in
            capturedImage = image
            exp.fulfill()
        }
        
        sut.cancelLoad(imageURL: .any)
        wait(for: [exp], timeout: 0.1)
        XCTAssertNil(capturedImage)
    }
    
    func test_wantToShowDetails_askRouterToShow() {
        let dogInteractor = DogBreedsInteractorSpy()
        let router = CuteDogsListPresenterRouterSpy()
        let sut = makeSUT(dogInteractor: dogInteractor,
                          router: router)
        
        let exp = expectation(description: "waiting completion")
        
        dogInteractor.fetchMoreCuteDogsAction = { _ in
            return [.anyDogBreed]
        }

        sut.loadMoreDogBreeds(completion: { _ in
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 0.1)
        sut.wantToShowDetails(id: CuteDog.anyDogBreed.id)
        XCTAssertEqual(router.wantToShowDetailsInput, [.anyDogBreed])
        
    }
    
    func makeSUT(dogInteractor: DogBreedsInteractor = DogBreedsInteractorSpy(),
                 imageLoaderInteractor: ImageLoaderInteractor = ImageLoaderInteractorSpy(),
                 router: CuteDogsListPresenterRouter = CuteDogsListPresenterRouterSpy(),
                 file: StaticString = #filePath,
                 line: UInt = #line) -> CuteDogsListViewControllerPresenter {
        
        let sut = CuteDogsListPresenter(dogInteractor: dogInteractor,
                                        imageLoaderInteractor: imageLoaderInteractor,
                                        router: router)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
