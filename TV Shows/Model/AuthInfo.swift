//
//  AuthInfo.swift
//  TV Shows
//
//  Created by Frane Sučić on 03.08.2023..
//

import Foundation

struct AuthInfo: Codable {
    let expiry: String
    let tokenType: String
    let uid: String
    let accessToken: String
    let client: String
    
    enum CodingKeys: String, CodingKey {
        case expiry
        case tokenType = "token-type"
        case uid
        case accessToken = "access-token"
        case client
    }
    
    var headers: [String: String] {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let data = try JSONSerialization.jsonObject(with: jsonData)
            return data as? [String: String] ?? [:]
        } catch {
            return [:]
        }
    }
    
    init(headers: [String: String]) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(AuthInfo.self, from: jsonData)
    }
    
}
