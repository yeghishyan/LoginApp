//
//  SignupViewModel.swift
//

import Foundation


class SignupViewModel {
    weak var coordinator: AuthCoordinator?
    private let authService: AuthService
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        self.authService = AuthService(url: "")
    }
    
    func signup(username: String, password: String, completion: @escaping (Result<String?, LoginError>)-> Void) {
        self.authService.authenticate(username: username, password: password) { result, error  in
            if error != nil {
                completion(.failure(LoginError.serviceError(error)))
            }
            completion(.success(result))
            self.coordinator?.didAuthenticate()
        }
    }
    
    func signin() {
        self.coordinator?.showSinginView()
    }
}
