//
//  PlayListResponse.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 08/08/2022.
//

import Foundation

struct PlayListResponse: Codable {
    let _id: String
    let name: String
    let image: URL?
    let thumbnail: URL?
    let createdAt: String
    let songs: [Song]
}


