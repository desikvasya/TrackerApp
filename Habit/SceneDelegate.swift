//
//  SceneDelegate.swift
//  Habit
//
//  Created by Denis on 29.05.2023.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if UserDefaults.standard.bool(forKey: "isOnboardingShown") {
            window.rootViewController = MainTabBarViewController()
        } else {
            let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            window.rootViewController = onboardingVC
            UserDefaults.standard.set(true, forKey: "isOnboardingShown")
        }
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
