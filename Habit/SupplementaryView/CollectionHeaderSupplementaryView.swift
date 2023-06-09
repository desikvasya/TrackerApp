//
//  CollectionHeaderSupplementaryView.swift
//  TrackerApp
//
//  Created by Denis on 29.05.2023.
//

import UIKit
// Представление, определяющее header для всех коллекций
final class CollectionHeaderSupplementaryView: UICollectionReusableView {
    
    // MARK: - Свойства
    var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Инициализатор
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Настройка внешнего вида
    private func setupView() {
        addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
