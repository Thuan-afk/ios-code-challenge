//
//  PhotoCacheManager.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import Foundation
import UIKit

class PhotoCacheManager {
    static let shared = PhotoCacheManager()
    
    private var tasks: [String: URLSessionDataTask] = [:]

    private let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 120 * 1024 * 1024
        cache.countLimit = 200
        return cache
    }()

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: urlString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func loadImage(from urlString: String) {
        if cache.object(forKey: urlString as NSString) != nil {
            return
        }

        guard let url = URL(string: urlString) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: urlString as NSString)
            }
            self.tasks.removeValue(forKey: urlString)
        }

        tasks[urlString] = task
        task.resume()
    }
    
    func cancelLoad(for urlString: String) {
        tasks[urlString]?.cancel()
        tasks.removeValue(forKey: urlString)
    }
}
