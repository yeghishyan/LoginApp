//
//  AuthService.swift
//

import Foundation

enum AuthServiceError: Error {
    case FailedRequest
    case InvalidResponse
    case Unknown
}

extension AuthServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .FailedRequest:
            return NSLocalizedString("Failed Request", comment: "")
        case .InvalidResponse:
            return NSLocalizedString("Invalid Response", comment: "")
        case .Unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
}

class AuthService {
    typealias AuthCompletion = (String?, AuthServiceError?) -> ()
    
    private let baseURL: URL?
    
    init(url: String) {
        self.baseURL = URL(string: url)
    }
    
    func authenticate(username: String, password: String, completion: @escaping AuthCompletion) {
        return completion("success", nil)
        
        guard let url = baseURL else { return }
        
        let authData = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.signIn(data: data, response: response, error: error, completion: completion)
            }
        }.resume()
    }
    
    //is @escaping necessary
    func signIn(data: Data?, response: URLResponse?, error: Error?, completion: @escaping AuthCompletion) {
        if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
            return completion(nil, .FailedRequest)
        }
        
        guard let data = data else {
            return completion(nil, .InvalidResponse)
        }
        
        do {
            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
            completion(authResponse.accessToken, nil)
        } catch {
            completion(nil, .Unknown)
        }
    }
}
