//
//  AppDelegate.swift
//  Habit
//
//  Created by Denis on 29.05.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let window = UIWindow()
//        window.rootViewController = MainTabBarViewController()
//        window.makeKeyAndVisible()
//        self.window = window
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "DataModel")
         container.loadPersistentStores { description, error in
             if let error {
                 print(error.localizedDescription)
             }
         }
         return container
     }()

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
