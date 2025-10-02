//
//  PhotoApiService.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 01/10/2025.
//

import Foundation

class PhotoApiService {
    
    private let endpoint = kAppDelegate.appDIContainer.appConfiguration.apiBaseURL
    
    func fetchPhotos(page: Int, limit: Int) async throws -> [PhotoDTO] {
        let urlString = "\(endpoint)/v2/list?page=\(page)&limit=\(limit)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([PhotoDTO].self, from: data)
    }
}
