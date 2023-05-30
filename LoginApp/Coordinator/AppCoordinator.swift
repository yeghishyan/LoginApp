//
//  AppCoordinator.swift
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    var isLoggiedIn: Bool = false
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if !isLoggiedIn {
            showMainView()
        } else {
            showAuthView()
        }
    }
}

extension AppCoordinator {
    func showMainView() {
        let mainCoordinator = MainCoordinator(navigationController)
        mainCoordinator.parentCoordinator = self
        //mainCoordinator.delegate = self
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
    }
    
    func showAuthView() {
        let authCoordinator = AuthCoordinator(navigationController)
        authCoordinator.parentCoordinator = self
        //authCoordinator.delegate = self
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
}
