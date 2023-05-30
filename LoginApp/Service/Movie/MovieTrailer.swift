//
//  MovieTrailer.swift
//

import Foundation

struct MovieTrailerResult: Decodable {
    var id: Int
    var results: [MovieTrailer]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        results = try container.decode([MovieTrailer].self, forKey: .results)
    }
    
}

struct MovieTrailer: Decodable {
    var name: String
    var key: String
    var site: String
    var official: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case key = "key"
        case site = "site"
        case official = "official"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        key = try container.decode(String.self, forKey: .key)
        site = try container.decode(String.self, forKey: .site)
        official = try container.decode(Bool.self, forKey: .official)
    }
    
}

