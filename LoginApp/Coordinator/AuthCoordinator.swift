//
//  AuthCoordinator.swift
//

import Foundation
import UIKit

class AuthCoordinator: Coordinator {
    weak var parentCoordinator: AppCoordinator?
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let loginViewController: LoginViewController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.loginViewController = LoginViewController()
    }
    
    func start() {
        self.loginViewController.loginViewModel = LoginViewModel(coordinator: self)
        navigationController.setViewControllers([loginViewController], animated: true)
    }
}

extension AuthCoordinator {
    func didAuthenticate() {
        parentCoordinator?.childDidFinish(self)
        parentCoordinator?.showMainView()
    }
    
    func showSignupView() {
        let signupViewController = SignupViewController()
        signupViewController.signupViewModel = SignupViewModel(coordinator: self)
        navigationController.pushViewController(signupViewController, animated: true)
    }
    
    func showSinginView() {
        navigationController.popToRootViewController(animated: true)
    }
}
