//
//  AppFlowCoordinator.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let photoSceneDIContainer = appDIContainer.makePhotosSceneDIContainer()
        let flow = photoSceneDIContainer.makeMainFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
