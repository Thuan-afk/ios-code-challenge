//
//  PhotosViewModel.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import Foundation
import Combine

protocol PhotosViewModelInput {
    var query: String { get set }
    func loadImages()
}

protocol PhotosViewModelOutput: AnyObject {
    var photos: [Photo] { get }
    var errorMessage: String? { get }
    var isLoading: Bool { get }
}

class PhotosViewModel: ObservableObject, PhotosViewModelInput, PhotosViewModelOutput {
    
    private let photosUseCase: PhotosUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private var page = 1
    private let limit = 100
    private var hasMorePages = true
    
    //Input
    @Published var query: String = ""
    
    //Output
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false
    
    private var allImages: [Photo] = []
    
    init(photosUseCase: PhotosUseCase) {
        self.photosUseCase = photosUseCase
        bind()
    }
    
    private func bind() {
        $query
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.filterImages(query: text)
            }
            .store(in: &cancellables)
    }
    
    func loadImages() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true
        
        Future<[Photo], Error> { [weak self] promise in
            guard let self = self else {
                    promise(.success([]))
                    return
                }
            Task {
                do {
                    let data = try await self.photosUseCase.execute(page:self.page, limit: self.limit)
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
            if data.isEmpty {
                self.hasMorePages = false
            }
            self.page += 1
            self.allImages += data
            self.photos = allImages
        }
        .store(in: &cancellables)
    }
    
    private func filterImages(query: String) {
        if query.isEmpty {
            photos = allImages
        } else {
            photos = allImages.filter {
                $0.id.contains(query) ||
                $0.author.localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    func refreshPhotos() {
        page = 1
        hasMorePages = true
        photos = []
        photos.removeAll()
    }
}
