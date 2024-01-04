//
//  Show.swift
//  TV Shows
//
//  Created by Frane Sučić on 23.07.2023..
//

import Foundation

struct Show: Decodable {
    let id: String
    let averageRating: Int?
    let description: String?
    let imageUrl: String
    let noOfReviews: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case averageRating = "average_rating"
        case description
        case imageUrl = "image_url"
        case noOfReviews = "no_of_reviews"
        case title
    }
}

struct ShowsResponse: Decodable {
    let shows: [Show]
}
