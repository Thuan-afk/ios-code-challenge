//
//  PhotoDTO.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 01/10/2025.
//

import Foundation

struct PhotoDTO: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}

extension PhotoDTO {
    func toEntity() -> Photo {
        Photo(
            id: id,
            author: author,
            width: width,
            height: height,
            url: url,
            download_url: download_url
        )
    }
}
