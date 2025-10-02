//
//  MockPhotosRepository.swift
//  IOSCodeChallengeTests
//
//  Created by Hoa Thuan on 02/10/2025.
//

import Foundation
@testable import IOSCodeChallenge

class MockPhotosRepository: PhotosRepository {
    var shouldReturnError = false
    var photos: [Photo] = []

    enum MockError: Error {
        case fetchFailed
    }

    func fetchPhotos(page: Int, limit: Int) async throws -> [IOSCodeChallenge.Photo] {
        if shouldReturnError {
            throw MockError.fetchFailed
        }
        return photos
    }
}
