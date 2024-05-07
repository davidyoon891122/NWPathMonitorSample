//
//  SceneDelegate.swift
//  NWPathMonitorSample
//
//  Created by Davidyoon on 5/7/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        
        let navigator = MainNavigator(navigationController: navigationController)
        navigator.toView()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }

}

