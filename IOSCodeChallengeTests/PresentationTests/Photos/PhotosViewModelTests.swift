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
    
    // MARK: - Load Success
    func test_LoadPhotos_Success() async {
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
        
        let expectationPhotos = expectation(description: "Photos updated")
        let expectationLoading = expectation(description: "Loading state updated")
        
        var didFulfillPhotos = false
        var didFulfillLoading = false
        
        viewModel.$photos
            .dropFirst()
            .sink { photos in
                if !didFulfillPhotos {
                    XCTAssertEqual(photos.count, 2)
                    didFulfillPhotos = true
                    expectationPhotos.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading && !didFulfillLoading {
                    didFulfillLoading = true
                    expectationLoading.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadImages()
        
        await fulfillment(of: [expectationPhotos, expectationLoading], timeout: 2)
    }
    
    // MARK: - Load Failure
    func test_LoadPhotos_Failure() async {
        let mockRepo = MockPhotosRepository()
        mockRepo.shouldReturnError = true
        
        let useCase = PhotosUseCase(repository: mockRepo)
        let viewModel = PhotosViewModel(photosUseCase: useCase)
        
        let expectationError = expectation(description: "Error updated")
        let expectationLoading = expectation(description: "Loading state updated")
        
        var didFulfillError = false
        var didFulfillLoading = false
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if !didFulfillError {
                    XCTAssertNotNil(errorMessage)
                    didFulfillError = true
                    expectationError.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading && !didFulfillLoading {
                    didFulfillLoading = true
                    expectationLoading.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadImages()
        
        await fulfillment(of: [expectationError, expectationLoading], timeout: 2)
    }
    
    // MARK: - Search Photos
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
        let expectationFiltered = expectation(description: "Photos filtered to count == 1")
        
        var didFulfillLoading = false
        var didFulfillFiltered = false
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading && !didFulfillLoading {
                    didFulfillLoading = true
                    expectationLoading.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$photos
            .sink { photos in
                if photos.count == 1 && !didFulfillFiltered {
                    didFulfillFiltered = true
                    expectationFiltered.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadImages()
        
        // Chờ loadImages xong
        await fulfillment(of: [expectationLoading], timeout: 2)
        
        // Thực hiện search
        viewModel.query = "1"
        
        // Chờ filtered result
        await fulfillment(of: [expectationFiltered], timeout: 2)
        
        XCTAssertEqual(viewModel.photos.count, 1)
        XCTAssertEqual(viewModel.photos.first?.id, "1")
    }

}
