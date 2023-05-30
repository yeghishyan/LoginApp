//
//  Movie.swift
//

import Foundation

struct MovieResult: Decodable {
    var page: Int
    var results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
    }
}

struct Movie: Decodable {
    var id: Int
    var title: String
    var rating: Double
    var overview: String
    var path: String?
    var date: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "original_title"
        case rating = "vote_average"
        case overview = "overview"
        case date = "release_date"
        case path = "poster_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        rating = try container.decode(Double.self, forKey: .rating)
        overview = try container.decode(String.self, forKey: .overview)
        date = try container.decode(String.self, forKey: .date)
        path = try container.decode(String.self, forKey: .path)
    }
    
}

