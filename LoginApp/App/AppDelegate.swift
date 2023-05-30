//
//  AppDelegate.swift
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var window: UIWindow?
    
    private var navigationController: UINavigationController?
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.navigationController = UINavigationController()
        self.appCoordinator = AppCoordinator(self.navigationController!)
        
        window?.rootViewController = self.appCoordinator?.navigationController
        window?.makeKeyAndVisible()
        
        self.appCoordinator?.start()

        self.navigationController?.navigationBar.isTranslucent = true;
        self.navigationController?.view.backgroundColor = AppConfig.backgroundColor
        
        return true
    }
}

