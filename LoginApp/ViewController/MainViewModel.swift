//
//  MainViewModel.swift
//

import Foundation

class MainViewModel {
    weak var coordinator: MainCoordinator?
    
    var movies: [Movie] = [] { didSet { print("[model] loaded movies count: \(movies.count)") } }
    var page: Int = 1
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    func logOut() {
        self.coordinator?.didLogOut()
    }
}
