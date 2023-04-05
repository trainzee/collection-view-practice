//
//  Photo.swift
//  CellTest
//
//  Created by Dmitry on 29.03.2023.
//

import Foundation

struct ImageList: Codable {
    let total: Int
    let results: [ImageInfo]
}

struct ImageInfo: Codable {
    let width: Int
    let height: Int
    let urls: Urls
}

struct Urls: Codable {
    let regular: String
    let thumb: String
}
