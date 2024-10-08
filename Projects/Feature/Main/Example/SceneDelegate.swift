//
//  SceneDelegate.swift
//  FeatureMainInterface
//
//  Created by 지연 on 8/29/24.
//

import UIKit

import FeatureMain

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(
//            rootViewController: HomeViewController()
//            rootViewController: HotViewController()
//            rootViewController: NewsViewController(url: URL(string: "https://www.google.com"))
            rootViewController: SettingsViewController()
//            rootViewController: MyNewsHabitViewController()
        )
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
