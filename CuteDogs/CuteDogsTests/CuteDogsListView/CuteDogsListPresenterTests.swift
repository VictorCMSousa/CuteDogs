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
        let pageSize = 200
        let pageNumber = 10
        let sut = makeSUT(dogInteractor: dogInteractor,
                          pageSize: pageSize,
                          pageNumber: pageNumber)
        let exp = expectation(description: "waiting completion")
        var capturedPageSize = 0
        var capturedPageNumber = 0

        dogInteractor.fetchBreedsAction = { pageSize, pageNumber in
            capturedPageSize = pageSize
            capturedPageNumber = pageNumber
            return []
        }

        sut.loadMoreDogBreeds(completion: { _ in
            exp.fulfill()
        })


        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(capturedPageSize, pageSize)
        XCTAssertEqual(capturedPageNumber, pageNumber)
    }

    func test_loadMoreDogsBreed_completionWithDogs() {

        let dogInteractor = DogBreedsInteractorSpy()
        let sut = makeSUT(dogInteractor: dogInteractor)
        let exp = expectation(description: "waiting completion")
        let cuteDog = CuteDog.anyDogBreed

        var capturedResult: Result<[CuteDogsCellConfiguration], ApiError>? = nil
        dogInteractor.fetchBreedsAction = { _, _ in
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

        dogInteractor.fetchBreedsAction = { _, _ in
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
    
    func test_loadMoreDogsBreed_fechedAllPreventRequest() {

        let dogInteractor = DogBreedsInteractorSpy()
        let sut = makeSUT(dogInteractor: dogInteractor,
                          pageSize: 21,
                          pageNumber: 1,
                          fetchedAll: true)
        let exp = expectation(description: "waiting completion")
        var capturedPageSize = 0
        var capturedPageNumber = 0
        var capturedResult: Result<[CuteDogsCellConfiguration], ApiError>? = nil
        
        dogInteractor.fetchBreedsAction = { pageSize, pageNumber in
            capturedPageSize = pageSize
            capturedPageNumber = pageNumber
            return [.anyDogBreed]
        }

        sut.loadMoreDogBreeds(completion: { result in
            capturedResult = result
            exp.fulfill()
        })

        wait(for: [exp], timeout: 0.1)

        switch capturedResult {
        case .success(let dogs):
            XCTAssertEqual(dogs, [])
            XCTAssertEqual(capturedPageSize, 0)
            XCTAssertEqual(capturedPageNumber, 0)
        default:
            XCTFail("Completion must succeeded")
        }
    }
    
    func test_loadMoreDogsBreedTwice_increasePageNumber() {

        let dogInteractor = DogBreedsInteractorSpy()
        let sut = makeSUT(dogInteractor: dogInteractor,
                          pageSize: 1,
                          pageNumber: 0)
        let exp = expectation(description: "waiting completion")
        var capturedPageSize = 0
        var capturedPageNumber = 0
        var capturedResult: Result<[CuteDogsCellConfiguration], ApiError>? = nil
        
        dogInteractor.fetchBreedsAction = { pageSize, pageNumber in
            capturedPageSize = pageSize
            capturedPageNumber = pageNumber
            return [.anyDogBreed]
        }

        sut.loadMoreDogBreeds(completion: { _ in
            
            sut.loadMoreDogBreeds(completion: { result in
                capturedResult = result
                exp.fulfill()
            })
        })
        
        wait(for: [exp], timeout: 0.1)

        switch capturedResult {
        case .success:
            XCTAssertEqual(capturedPageSize, 1)
            XCTAssertEqual(capturedPageNumber, 1)
        default:
            XCTFail("Completion must succeeded")
        }
    }
    
    func test_loadMoreDogsBreedResultLessThanPageSize_preventNextRequest() {

        let dogInteractor = DogBreedsInteractorSpy()
        let sut = makeSUT(dogInteractor: dogInteractor,
                          pageSize: 10,
                          pageNumber: 0)
        let exp = expectation(description: "waiting completion")
        var capturedPageSize = 0
        var capturedPageNumber = 0
        var capturedResult: Result<[CuteDogsCellConfiguration], ApiError>? = nil
        
        dogInteractor.fetchBreedsAction = { pageSize, pageNumber in
            capturedPageSize = pageSize
            capturedPageNumber = pageNumber
            return [.anyDogBreed]
        }

        sut.loadMoreDogBreeds(completion: { _ in
            
            sut.loadMoreDogBreeds(completion: { result in
                capturedResult = result
                exp.fulfill()
            })
        })
        
        wait(for: [exp], timeout: 0.1)

        switch capturedResult {
        case .success(let dogs):
            XCTAssertEqual(dogs, [])
            XCTAssertEqual(capturedPageSize, 10)
            XCTAssertEqual(capturedPageNumber, 0)
        default:
            XCTFail("Completion must succeeded")
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
        
        dogInteractor.fetchBreedsAction = { _, _ in
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
                 pageSize: Int = 20,
                 pageNumber: Int = 0,
                 fetchedAll: Bool = false,
                 file: StaticString = #filePath,
                 line: UInt = #line) -> CuteDogsListViewControllerPresenter {
        
        let sut = CuteDogsListPresenter(dogInteractor: dogInteractor,
                                        imageLoaderInteractor: imageLoaderInteractor,
                                        router: router,
                                        pageSize: pageSize,
                                        pageNumber: pageNumber,
                                        fetchedAll: fetchedAll)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
