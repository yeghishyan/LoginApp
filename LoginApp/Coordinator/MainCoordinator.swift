//
//  MainCoordinator.swift
//

import UIKit

class MainCoordinator: Coordinator {
    weak var parentCoordinator: AppCoordinator?
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var mainViewController: MainViewController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.mainViewController = MainViewController()
    }
    
    func start() {
        self.mainViewController.mainViewModel = MainViewModel(coordinator: self)
        navigationController.setViewControllers([mainViewController], animated: true)
    }
}

extension MainCoordinator {
    func didLogOut() {
        parentCoordinator?.childDidFinish(self)
        parentCoordinator?.showAuthView()
    }
    
    func showMainView() {
        navigationController.popToRootViewController(animated: false)
    }
}
