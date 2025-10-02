//
//  AppDIContainer.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - DIContainer
    func makePhotosSceneDIContainer() -> PhotosSceneDIContainer {
        return PhotosSceneDIContainer()
    }
}
