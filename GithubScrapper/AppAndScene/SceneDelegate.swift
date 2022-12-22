//
//  SceneDelegate.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = AppCoordinator().rootViewController
        window?.makeKeyAndVisible()
    }

}

