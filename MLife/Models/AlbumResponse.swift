//
//  AlbumResponse.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 01/07/2022.
//

import Foundation

struct AlbumResponse: Codable {
    let _id: String
    let name: String
    let artists_name: String
    let thumbnail: URL?
    let songs: [Song]
}

