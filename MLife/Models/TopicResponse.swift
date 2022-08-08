//
//  TopicResponse.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 08/08/2022.
//

import Foundation

struct TopicResponse: Codable {
    let name: String
    let title: String
    let image: URL?
    let categories: [Category]
}

