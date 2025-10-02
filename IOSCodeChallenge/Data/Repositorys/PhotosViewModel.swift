//
//  PhotosViewModel.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import Foundation
import Combine

class PhotosViewModel: ObservableObject {
    
    private let photosUseCase: PhotosUseCase
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false
    
    init(photosUseCase: PhotosUseCase) {
        self.photosUseCase = photosUseCase
    }
    
    func loadImages(page: Int = 1, limit: Int = 100) {
        isLoading = true
        
        Future<[Photo], Error> { [weak self] promise in
            guard let self = self else {
                    promise(.success([]))
                    return
                }
            Task {
                do {
                    let data = try await self.photosUseCase.execute(page: page, limit: limit)
                    promise(.success(data))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false
            if case .failure(let error) = completion {
                self.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] data in
            guard let self = self else { return }
            self.photos = data
        }
        .store(in: &cancellables)
    }
}
