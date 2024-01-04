//
//  Review.swift
//  TV Shows
//
//  Created by Frane Sučić on 23.07.2023..
//

import Foundation

struct Review: Decodable {
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
}

struct ReviewsResponse: Decodable {
    var reviews: [Review]
}

struct SingleReviewResponse: Decodable {
    let review: Review
}

struct ReviewParameters: Codable {
    let rating: Int
    let comment: String
    let showId: String
    
    enum CodingKeys: String, CodingKey {
        case rating
        case comment
        case showId = "show_id"
    }
}
