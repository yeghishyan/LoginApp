//
//  Credentials.swift
//

import Foundation

struct Credentials //: Codable {
{
    var idNumber: Int
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case idNumber = "id"
        case password = "password"
    }
    
    //init(from decoder: Decoder) throws {}
    //public func encode(to encoder: Encoder) throws {}
}

struct AuthResponse: Decodable {
    let accessToken: String
}
