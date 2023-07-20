//
//  AppDelegate.swift
//  Habit
//
//  Created by Denis on 29.05.2023.
//

import UIKit
import CoreData
import YandexMobileMetrica


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var statisticsViewModel = StatisticsViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let configuration = YMMYandexMetricaConfiguration.init(apiKey: "50dbab5e-ef72-4f65-baa2-e2b72e7ff853") else {
            return true
        }
        YMMYandexMetrica.activate(with: configuration)
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
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
