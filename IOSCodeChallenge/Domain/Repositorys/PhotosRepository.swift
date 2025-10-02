//
//  PhotosRepository.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 01/10/2025.
//

import Foundation

protocol PhotosRepository {
    func fetchPhotos(page: Int, limit: Int) async throws -> [Photo]
}
