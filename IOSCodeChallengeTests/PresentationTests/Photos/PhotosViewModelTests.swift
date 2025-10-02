//
//  PhotosViewModelTests.swift
//  IOSCodeChallengeTests
//
//  Created by Hoa Thuan on 02/10/2025.
//

import XCTest
import Combine
@testable import IOSCodeChallenge

final class PhotosViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()

    func test_LoadPhotos_Success() async {
        let mockRepo = MockPhotosRepository()
        mockRepo.photos = [
            Photo(id: "0", author: "Alejandro Escamilla", width: 5000, height: 3333, url: "https://unsplash.com/photos/yC-Yzbqy7PY", download_url: "https://picsum.photos/id/0/5000/3333", hightCell: 0),
            Photo(id: "1", author: "Alejandro Escamilla", width: 5000, height: 3333, url: "https://unsplash.com/photos/LNRyGwIJr5c", download_url: "https://picsum.photos/id/1/5000/3333", hightCell: 0)
        ]
        let useCase = PhotosUseCase(repository: mockRepo)
        let viewModel = PhotosViewModel(photosUseCase: useCase)
        let expectationPhotos = expectation(description: "Photos updated")
        let expectationLoading = expectation(description: "Loading state updated")

        viewModel.$photos
            .dropFirst()
            .sink { photos in
                XCTAssertEqual(photos.count, 2)
                expectationPhotos.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectationLoading.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadImages()

        await fulfillment(of: [expectationPhotos, expectationLoading], timeout: 1)
    }

    func test_LoadPhotos_Failure() async {
        let mockRepo = MockPhotosRepository()
        mockRepo.shouldReturnError = true
        let useCase = PhotosUseCase(repository: mockRepo)
        let viewModel = PhotosViewModel(photosUseCase: useCase)

        let expectationError = expectation(description: "Error updated")
        let expectationLoading = expectation(description: "Loading state updated")

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectationError.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectationLoading.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadImages()

        await fulfillment(of: [expectationError, expectationLoading], timeout: 1)
    }
    
    func test_SearchPhotos() async {
        let mockRepo = MockPhotosRepository()
            mockRepo.photos = [
                Photo(id: "0", author: "Alejandro Escamilla", width: 5000, height: 3333,
                      url: "https://unsplash.com/photos/yC-Yzbqy7PY",
                      download_url: "https://picsum.photos/id/0/5000/3333", hightCell: 0),
                Photo(id: "1", author: "Alejandro Escamilla", width: 5000, height: 3333,
                      url: "https://unsplash.com/photos/LNRyGwIJr5c",
                      download_url: "https://picsum.photos/id/1/5000/3333", hightCell: 0)
            ]

            let useCase = PhotosUseCase(repository: mockRepo)
            let viewModel = PhotosViewModel(photosUseCase: useCase)

            let expectationLoading = expectation(description: "Loading state updated")
            let filteredExpectation = expectation(description: "Photos filtered to count == 1")

            viewModel.$isLoading
                .dropFirst()
                .sink { isLoading in
                    if !isLoading {
                        expectationLoading.fulfill()
                    }
                }
                .store(in: &cancellables)

            viewModel.$photos
                .sink { photos in
                    if photos.count == 1 {
                        filteredExpectation.fulfill()
                    }
                }
                .store(in: &cancellables)

            viewModel.loadImages()

            await fulfillment(of: [expectationLoading], timeout: 2)

            viewModel.query = "1"

            await fulfillment(of: [filteredExpectation], timeout: 2)

            XCTAssertEqual(viewModel.photos.count, 1)
            XCTAssertEqual(viewModel.photos.first?.id, "1")
    }

}
