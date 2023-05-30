//
//  MovieAPI.swift
//

import Foundation

enum MovieApiError: Error {
    case FailedRequest(String)
    case InvalidResponse
    case Unknown
    
    public var errorDescription: String? {
        switch self {
        case .FailedRequest(let string):
            return NSLocalizedString("Failed Request", comment: string)
        case .InvalidResponse:
            return NSLocalizedString("Invalid Response", comment: "")
        case .Unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
}

class MovieAPI {
    
    static let shared = MovieAPI()
    private let session = URLSession.shared
    private let url = "https://api.themoviedb.org/3/"
    
    private func getAPIKey() -> String {
        return "0e15af59bdfb7a0361a6ebb9a50575ed"
    }
    
    func topSuggestions(page: Int, completion: @escaping ([Movie]?, MovieApiError?) -> Void) {
        print("fetching data: " + #function)
        let urlExample = "https://api.themoviedb.org/3/discover/movie?api_key=0e15af59bdfb7a0361a6ebb9a50575ed&sort_by=popularity.desc&language=en-US&page=1"
        
        let _ = [
            "\(url)",                   "discover/movie",
            "?api_key=",                "\(getAPIKey())",
            "&sort_by=",                "popularity.desc",
            "&language=",               "en-US",
            "&primary_release_year=",   "2023",
            "&page=",                   "\(page)",
        ]
        
        guard let url = URL(string: urlExample) else {
            completion(nil, .FailedRequest("Invalid url"))
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                return completion(nil, .FailedRequest(error.localizedDescription))
            }
            
            guard let data = data else {
                return completion(nil, .InvalidResponse)
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResult.self, from: data)
                let movies = response.results
                completion(movies, nil)
            } catch {
                completion(nil, .Unknown)
            }
            }.resume()
    }
    
    func movieTrailer(id: Int, completion: @escaping ([Movie]?, MovieApiError?) -> Void) {
        print("fetching data: " + #function)
        let urlExample = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=0e15af59bdfb7a0361a6ebb9a50575ed"
        
        guard let url = URL(string: urlExample) else {
            completion(nil, .FailedRequest("Invalid url"))
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                return completion(nil, .FailedRequest(error.localizedDescription))
            }
            
            guard let data = data else {
                return completion(nil, .InvalidResponse)
            }
            
            do {
                let response = try JSONDecoder().decode(MovieResult.self, from: data)
                let movieTrailer = response.results
                completion(movieTrailer, nil)
            } catch {
                completion(nil, .Unknown)
            }
            }.resume()
    }
}
