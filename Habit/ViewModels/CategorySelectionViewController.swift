//
//  CategorySelectionViewController.swift
//  Habit
//
//  Created by Denis on 30.05.2023.
//

import UIKit

final class CategorySelectionViewController: UIViewController {
    
    private let viewModel: CategoryViewModel
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Свойства
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let categoriesTable: UITableView = {
        let table = UITableView()
        table.register(CategoryCell.self, forCellReuseIdentifier: "category")
        table.isScrollEnabled = true
        table.separatorStyle = .singleLine
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 16
        table.allowsMultipleSelection = false
        return table
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "star"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Привычки и события можно
        объединить по смыслу
        """
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let addCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(showNewCategoryViewController), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Метод жизненного цикла viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    // MARK: - Настройка внешнего вида
    private func setupView() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategories), name: Notification.Name("categories_added"), object: nil)
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(addCategoryButton)
        view.addSubview(categoriesTable)
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        stackView.addArrangedSubview(starImage)
        stackView.addArrangedSubview(questionLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            categoriesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26),
            categoriesTable.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -26)
        ])
        if !viewModel.categories.isEmpty {
            stackView.isHidden = true
        }
        showCategories()
    }
    
    private func bind() {
        viewModel.isCategoryChoosed = { [weak self] isOk in
            guard let self = self else { return }
            if isOk {
                self.dismiss(animated: true)
                let notification = Notification(name: .categoriesDidChanged)
                NotificationCenter.default.post(notification)
            } else {
                print("Ошибка выбора категории")
            }
        }
        viewModel.isCategoryDeleted = { [weak self] index in
            guard let self = self else { return }
            self.categoriesTable.deleteRows(at: [index], with: .fade)
            if self.viewModel.categories.isEmpty {
                self.categoriesTable.isHidden = true
                self.stackView.isHidden = false
            }
        }
    }
    
    
    @objc
    private func updateCategories() {
        showCategories()
        categoriesTable.reloadData()
    }
    
    private func showCategories() {
        if !viewModel.categories.isEmpty {
            stackView.isHidden = !viewModel.categories.isEmpty
            categoriesTable.isHidden = viewModel.categories.isEmpty
        } else {
            stackView.isHidden = viewModel.categories.isEmpty
            categoriesTable.isHidden = !viewModel.categories.isEmpty
        }
    }
    
    @objc
    private func showNewCategoryViewController() {
        let viewController = NewCategoryViewController(categoryViewModel: viewModel)
        show(viewController, sender: self)
    }
    
}

// MARK: - Расширение для UITableViewDataSource
extension CategorySelectionViewController: UITableViewDataSource {
    
    // MARK: Метод, возвращающий количество строк в секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    // MARK: Метод создания и настройки ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        guard let categoryCell = cell as? CategoryCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        categoryCell.title.text = viewModel.categories[indexPath.row]
        return categoryCell
    }
    
    // MARK: Метод, определяющий, может ли строка таблицы быть редактируемой
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Метод, обрабатывающий удаление строки таблицы
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteCategory(at: indexPath)
    }
    
}

// MARK: - Расширение для UITableViewDelegate
extension CategorySelectionViewController: UITableViewDelegate {
    
    // MARK: Метод, определяющий высоту строки таблицы
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // MARK: Метод конфигурации ячеек перед их отображением
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        }
    }
    
    // MARK: Метод, вызываемый при нажатии на строку таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? CategoryCell
        cell?.checkbox.image = UIImage(systemName: "checkmark")
        
        viewModel.didChooseCategory(name: cell?.title.text ?? "-")
    }
    
    // MARK: Метод, определяющий заголовок для удаления строки таблицы
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
}

// MARK: - Расширение для Notification
extension Notification.Name {
    static let categoriesDidChanged = Notification.Name("category_changed")
}
