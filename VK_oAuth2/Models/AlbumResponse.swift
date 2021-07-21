//
//  AlbumResponse.swift
//  VK_oAuth2
//
//  Created by iMac on 20.07.2021.
//

import Foundation

struct AlbumResponse: Codable {
    let response: Album
}


struct Album: Codable {
    let count: Int
    let items: [PhotoModel]
}

struct PhotoModel: Codable {
    let date: Int
    let id: Int
    let sizes: [Size]
}

struct Size: Codable {
    let type: String
    let url: String
}
