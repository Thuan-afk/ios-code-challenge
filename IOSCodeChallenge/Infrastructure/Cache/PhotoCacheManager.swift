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
    
    private let ioQueue = DispatchQueue(label: "com.app.imageLoader", qos: .userInitiated)
    
    func loadImage(from urlString: String, originalWidth: Int, originalHeight: Int, completion: @escaping (UIImage?) -> Void) {
        if let cached = cache.object(forKey: urlString as NSString) {
            completion(cached)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let targetSize = scaleSizeToScreenWidth(originalWidth: CGFloat(originalWidth), originalHeight: CGFloat(originalHeight))
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            self.ioQueue.async {
                let image = self.downsample(data: data, to: targetSize)
                
                if let img = image {
                    self.cache.setObject(img, forKey: urlString as NSString)
                }
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
        }.resume()
    }
        
    private func downsample(data: Data, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: max(pointSize.width, pointSize.height) * scale
        ]
        
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    func preloadImage(from urlString: String, originalWidth: Int, originalHeight: Int) {
        if cache.object(forKey: urlString as NSString) != nil {
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        let targetSize = scaleSizeToScreenWidth(originalWidth: CGFloat(originalWidth), originalHeight: CGFloat(originalHeight))
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            
            self.ioQueue.async {
                if let image = self.downsample(data: data, to: targetSize) {
                    self.cache.setObject(image, forKey: urlString as NSString)
                }
            }
        }
        
        tasks[urlString] = task
        task.resume()
    }
    
    func cancelLoad(for urlString: String) {
        tasks[urlString]?.cancel()
        tasks.removeValue(forKey: urlString)
    }
    
    func scaleSizeToScreenWidth(originalWidth: CGFloat, originalHeight: CGFloat, screenWidth: CGFloat = UIScreen.main.bounds.width) -> CGSize {
        guard originalWidth > 0 else { return CGSize(width: screenWidth, height: screenWidth) }
        let scale = screenWidth / originalWidth
        let newHeight = originalHeight * scale
        return CGSize(width: screenWidth, height: newHeight)
    }
}
