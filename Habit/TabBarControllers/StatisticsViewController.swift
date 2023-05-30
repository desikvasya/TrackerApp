//
//  StatisticsViewController.swift
//  TrackerApp
//
//  Created by Denis on 29.05.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addPlaceholder()
    }
    
    // MARK: - Components
    
    private lazy var placeholderView: UIView = {
        let message = "Анализировать пока нечего"
        let imageName = "statsPlaceholder"
        guard let image = UIImage(named: imageName) else {
            fatalError("Failed to load image: \(imageName)")
        }
        
        return UIView.placeholderView(message: message, image: image)
    }()
    
    // MARK: - Appearance
    
    private func addPlaceholder() {
        view.backgroundColor = .white
        view.addSubview(placeholderView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
    private func setupNavBar() {
        title = "Статистика"
    }
}

extension UIView {
    static func placeholderView(message: String, image: UIImage) -> UIView {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let imageView = UIImageView(image: image)
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.alignment = .center
        
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(label)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        return vStack
    }
}
