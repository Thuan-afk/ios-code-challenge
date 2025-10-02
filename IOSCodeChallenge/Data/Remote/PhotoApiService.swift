//
//  PhotoApiService.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 01/10/2025.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
    case invalidStatusCode(Int)
    case noInternet
    case timeout
    case unknown(Error)
}

class PhotoApiService {
    
    private let endpoint = kAppDelegate.appDIContainer.appConfiguration.apiBaseURL
    
    func fetchPhotos(page: Int, limit: Int, maxRetries: Int = 2) async throws -> [PhotoDTO] {
        let urlString = "\(endpoint)/v2/list?page=\(page)&limit=\(limit)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.badURL
        }
        
        var attempts = 0
        while attempts <= maxRetries {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)

                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                    throw NetworkError.invalidStatusCode(code)
                }
                do {
                    return try JSONDecoder().decode([PhotoDTO].self, from: data)
                } catch {
                    throw NetworkError.decodingError
                }
            } catch let urlError as URLError {
                attempts += 1
                if attempts > maxRetries {
                    switch urlError.code {
                    case .timedOut:
                        throw NetworkError.timeout
                    case .notConnectedToInternet:
                        throw NetworkError.noInternet
                    default:
                        throw NetworkError.unknown(urlError)
                    }
                }
            } catch {
                throw NetworkError.unknown(error)
            }
        }
        throw URLError(.badServerResponse)
    }
}
