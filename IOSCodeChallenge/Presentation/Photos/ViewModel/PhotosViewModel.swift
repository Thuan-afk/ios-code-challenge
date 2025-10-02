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
    func cancelCallApi()
}

protocol PhotosViewModelOutput: AnyObject {
    var photos: [Photo] { get }
    var errorMessage: String? { get }
    var isLoading: Bool { get }
    var isFooterLoading: Bool { get }
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
    @Published private(set) var isFooterLoading: Bool = false
    
    private var allImages: [Photo] = []
    private var currentTask: Task<Void, Never>?
    
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
        guard !isLoading && !isFooterLoading && hasMorePages else { return }
        if (page == 1) {
            isLoading = true
        } else {
            isFooterLoading = true
        }
        
        Future<[Photo], Error> { [weak self] promise in
            guard let self = self else {
                    promise(.success([]))
                    return
                }
            self.currentTask = Task {
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
            self.isFooterLoading = false
            if case .failure(let error) = completion {
                if let netError = error as? NetworkError {
                    switch netError {
                    case .badURL:
                        print("URL is incorrect")
                    case .noData:
                        print("No data")
                    case .decodingError:
                        print("Decoding Error")
                    case .invalidStatusCode(let code):
                        self.errorMessage = "Server error: \(code)"
                    case .noInternet:
                        self.errorMessage = "No internet connection!"
                    case .timeout:
                        self.errorMessage = "Timeout!"
                    case .unknown(let err):
                        self.errorMessage = "Unknown error: \(err.localizedDescription)"
                    }
                } else {
                    self.errorMessage = error.localizedDescription
                }
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
    
    func cancelCallApi() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    deinit {
        cancelCallApi()
    }
}
