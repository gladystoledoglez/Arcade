//
//  ArcadeDetail.swift
//  FinalProject

import Foundation

struct ArcadeDetail: Codable {
    let id: Int
    let title: String
    let thumbnail: String
    let shortDescription: String
    let platform: String
    let genre: String
    let releaseDate: String
    let publisher: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnail
        case shortDescription = "short_description"
        case platform
        case genre
        case releaseDate = "release_date"
        case publisher
    }
}
