////
////  HomeViewController.swift
////  Habit
////
////  Created by Denis on 31.05.2023.
////
//
//import UIKit
//
//class HomeViewController: UITabBarController {
//
//    var onboarding: UIViewController?
//
//    init(onboarding: UIViewController?) {
//        self.onboarding = onboarding
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupTabs()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        presentOnboarding()
//    }
//}
//
//// MARK: - Appearance
//
//private extension HomeViewController {
//    func prepare(_ navigationController: UINavigationController) {
//        navigationController.navigationBar.prefersLargeTitles = true
//
//        navigationController.navigationBar.standardAppearance.largeTitleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.black,
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32)
//        ]
//    }
//
//    func setupTabs() {
//        tabBar.backgroundColor = UIColor.white
//        
//        let trackerVC = UINavigationController(rootViewController: TrackersViewController())
//        let statisticVC = UINavigationController(rootViewController: StatisticsViewController())
//        let controllers = [trackerVC, statisticVC]
//        viewControllers = controllers
//        
//        let font = UIFont.systemFont(ofSize: 10, weight: .medium)
//        let textAttributes = [NSAttributedString.Key.font: font]
//        
//        trackerVC.tabBarItem.setTitleTextAttributes(textAttributes, for: .normal)
//        trackerVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackerTabIcon"), selectedImage: nil)
//
//        statisticVC.tabBarItem.setTitleTextAttributes(textAttributes, for: .normal)
//        statisticVC.tabBarItem = UITabBarItem(title: "Cтатистика", image: UIImage(named: "statisticsTabIcon"), selectedImage: nil)
//
//      
//        tabBar.layer.shadowColor = UIColor.black.cgColor
//        tabBar.layer.shadowOpacity = 0.3
//        tabBar.layer.shadowOffset = .init(width: 0, height: -0.5)
//        tabBar.layer.masksToBounds = false
//
//        controllers.forEach(prepare)
//    }
//}
//
//// MARK: - Onboarding
//
//private extension HomeViewController {
//    func presentOnboarding() {
//        if let onboarding {
//            onboarding.modalPresentationStyle = .overFullScreen
//            present(onboarding, animated: false)
//            self.onboarding = nil
//        }
//    }
//}
