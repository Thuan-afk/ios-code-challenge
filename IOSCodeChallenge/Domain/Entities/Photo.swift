//
//  Photo.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 01/10/2025.
//

import Foundation
import UIKit

struct Photo {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}

extension Photo {
    func resizedURL() -> String {
        let resizeWidth = Int(UIScreen.main.bounds.width)
        let resizeHeight = (height * resizeWidth)/width
        return "https://picsum.photos/id/\(id)/\(resizeWidth)/\(resizeHeight)"
    }
}
