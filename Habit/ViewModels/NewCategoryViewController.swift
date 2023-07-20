//
//  NewCategoryViewController.swift
//  Habit
//
//  Created by Denis on 11.07.2023.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Свойства
    private let categoryViewModel: CategoryViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("NewCategoryViewController.title", comment: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("NewCategoryViewController.button", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(create), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let enterNameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = NSLocalizedString("NewCategoryViewController.search", comment: "")
        field.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        field.layer.cornerRadius = 16
        field.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = .always
        return field
    }()
    
    // MARK: - Методы
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupView()
        bind()
    }
    
    init(categoryViewModel: CategoryViewModel) {
        self.categoryViewModel = categoryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterNameTextField.heightAnchor.constraint(equalToConstant: 71),
            enterNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            enterNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupProperties() {
        view.addSubview(titleLabel)
        view.addSubview(enterNameTextField)
        view.addSubview(createButton)
        enterNameTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func activateButton() {
        if enterNameTextField.hasText {
            createButton.backgroundColor = .black
            createButton.isEnabled = true
        }
    }
    
    private func deactivateButton() {
        if !enterNameTextField.hasText {
            createButton.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
            createButton.isEnabled = false
        }
    }
    
    private func bind() {
        categoryViewModel.isCategoryAdded = { [self] result in
            switch result {
            case true:
                self.dismiss(animated: true)
                let notification = Notification(name: Notification.Name("categories_added"))
                NotificationCenter.default.post(notification)
            case false:
                showErrorAlert(message: "Ошибка добавления категории")
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func dismissKeyboard() {
        enterNameTextField.resignFirstResponder()
    }
    
    @objc
    private func create() {
        if let newCategory = enterNameTextField.text {
            categoryViewModel.addCategory(newCategory: newCategory)
        }
    }
    
}

// MARK: - Расширение для UITextFieldDelegate
extension NewCategoryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.hasText {
            activateButton()
        } else {
            deactivateButton()
        }
    }
    
}
