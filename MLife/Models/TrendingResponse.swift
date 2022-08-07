//
//  TrendingResponse.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 01/07/2022.
//

import Foundation

struct TredingResponse: Codable {
    let _id: String
    let song_id: Song?
    let description: String
    let image: URL?
}

