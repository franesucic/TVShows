//
//  User.swift
//  TV Shows
//
//  Created by Frane Sučić on 22.07.2023..
//

import Foundation

struct UserResponse: Codable {
    var user: User
}

struct User: Codable {
    
    let id: String
    let email: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case imageUrl = "image_url"
    }
    
}
