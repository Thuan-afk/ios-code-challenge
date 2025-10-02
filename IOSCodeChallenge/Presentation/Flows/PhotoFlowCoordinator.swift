//
//  PhotoFlowCoordinator.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import Foundation
import UIKit

class PhotoFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let photosSceneDIContainer: PhotosSceneDIContainer

    init(navigationController: UINavigationController, photosSceneDIContainer: PhotosSceneDIContainer) {
        self.navigationController = navigationController
        self.photosSceneDIContainer = photosSceneDIContainer
    }

    func start() {
        let vc = photosSceneDIContainer.makePhotosViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}
