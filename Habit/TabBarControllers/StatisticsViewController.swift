//
//  StatisticsViewController.swift
//  TrackerApp
//
//  Created by Denis on 29.05.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    private var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addPlaceholder()
    }
    
    // MARK: - Components
    
    private lazy var placeholderView: UIView = {
        let message = NSLocalizedString("StatisticsViewController.placeholderTitle", comment: "")
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
        if let navigationBar = navigationController?.navigationBar {
            var attributes = navigationBar.titleTextAttributes ?? [:]
            let boldFont = UIFont.boldSystemFont(ofSize: 34)
            attributes[NSAttributedString.Key.font] = boldFont
            navigationBar.titleTextAttributes = attributes
            
            let titleLabel = UILabel()
            titleLabel.text = NSLocalizedString( "StatisticsViewController.title", comment: "")
            titleLabel.font = boldFont
            titleLabel.sizeToFit()
            
            let containerView = UIView()
            containerView.addSubview(titleLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28)
            ])
            
            let leftBarItem = UIBarButtonItem(customView: containerView)
            navigationItem.leftBarButtonItem = leftBarItem
        }
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
