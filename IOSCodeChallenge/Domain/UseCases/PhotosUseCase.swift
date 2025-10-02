//
//  PhotosUseCase.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 01/10/2025.
//

import Foundation

struct PhotosUseCase {
    private let repository: PhotosRepository
    
    init(repository: PhotosRepository) {
        self.repository = repository
    }
    
    func execute(page: Int, limit: Int) async throws -> [Photo] {
        try await repository.fetchPhotos(page: page, limit: limit)
    }
}
