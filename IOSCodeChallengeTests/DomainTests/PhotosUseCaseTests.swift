//
//  PhotosUseCaseTests.swift
//  IOSCodeChallengeTests
//
//  Created by Hoa Thuan on 02/10/2025.
//

import XCTest
@testable import IOSCodeChallenge

final class PhotosUseCaseTests: XCTestCase {

    func test_GetPhotos_WhenSuccess() async throws {
        let mockRepo = MockPhotosRepository()
        mockRepo.photos = [
            Photo(id: "0", author: "Alejandro Escamilla", width: 5000, height: 3333, url: "https://unsplash.com/photos/yC-Yzbqy7PY", download_url: "https://picsum.photos/id/0/5000/3333"),
            Photo(id: "1", author: "Alejandro Escamilla", width: 5000, height: 3333, url: "https://unsplash.com/photos/LNRyGwIJr5c", download_url: "https://picsum.photos/id/1/5000/3333")
        ]
        let useCase = PhotosUseCase(repository: mockRepo)

        let result = try await useCase.execute(page: 1, limit: 10)

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.id, "0")
    }

    func test_GetPhotos_WhenRepositoryFails() async {
        let mockRepo = MockPhotosRepository()
        mockRepo.shouldReturnError = true
        let useCase = PhotosUseCase(repository: mockRepo)

        do {
            _ = try await useCase.execute(page: 1, limit: 10)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is MockPhotosRepository.MockError)
        }
    }
}
