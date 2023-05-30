//
//  LoginViewModel.swift
//

import Foundation

enum LoginError: Error {
    case invalidCredentials
    case serviceError(Error?)
    case validationError(String)
}

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

class LoginViewModel {
    typealias LoginResult = Result<String?, LoginError>
    
    weak var coordinator: AuthCoordinator?
    private let authService: AuthService
    private let passwordValidator = Validator(minLength: 8, lowercase: true)
    private let usernameValidator = Validator(minLength: 5)
    
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        self.authService = AuthService(url: "")
    }
    
    func isValidUsername(_ username: String) -> Bool {
        return usernameValidator.validate(username) == nil
    }
    
    func authenticate(username: String, password: String, completion: @escaping (LoginResult) -> Void) {
        if var message = usernameValidator.validate(username) {
            message = "Username " + message.lowercased()
            return completion(.failure(LoginError.validationError(message)))
        }
        if var message = passwordValidator.validate(password) {
            message = "Password " + message.lowercased()
            return completion(.failure(LoginError.validationError(message)))
        }
        
        self.authService.authenticate(username: username, password: password) { result, error  in
            if error != nil {
                completion(.failure(LoginError.serviceError(error)))
            }
            completion(.success(result))
            self.coordinator?.didAuthenticate()
        }
    }
    
    func signup() {
        self.coordinator?.showSignupView()
    }
}
