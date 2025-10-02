//
//  PhotosRepositoryImpl.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 01/10/2025.
//

import Foundation

class PhotosRepositoryImpl: PhotosRepository {
    private let apiService: PhotoApiService
    
    init(apiService: PhotoApiService) {
        self.apiService = apiService
    }
    
    func fetchPhotos(page: Int, limit: Int) async throws -> [Photo] {
        let dtos = try await apiService.fetchPhotos(page: page, limit: limit)
        return dtos.map { $0.toEntity() }
    }
}
