//
//  PhotosSceneDIContainer.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import UIKit

final class PhotosSceneDIContainer {

    init() {
    }
    
    // MARK: - Flow Coordinators
    func makeMainFlowCoordinator(navigationController: UINavigationController) -> PhotoFlowCoordinator {
        return PhotoFlowCoordinator(navigationController: navigationController, photosSceneDIContainer: PhotosSceneDIContainer())
    }
    
    // MARK: - API
    func makePhotoApiService() -> PhotoApiService {
        return PhotoApiService()
    }
    
    // MARK: - Repositories
    private func makePhotosRepository() -> PhotosRepository {
        return PhotosRepositoryImpl(apiService: makePhotoApiService())
    }

    // MARK: - UseCases
    func makePhotosUseCase() -> PhotosUseCase {
        return PhotosUseCase(repository: makePhotosRepository())
    }

    // MARK: - Photos
    func makePhotosViewModel() -> PhotosViewModel {
        return PhotosViewModel(photosUseCase: makePhotosUseCase())
    }
    
    func makePhotosViewController() -> PhotosViewController {
        return PhotosViewController.create(with: makePhotosViewModel())
    }
    
}
