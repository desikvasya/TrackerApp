//
//  CategoryViewModel.swift
//  Habit
//
//  Created by Denis on 11.07.2023.
//

import Foundation

typealias Binding<T> = (T) -> Void

protocol CategoryViewModelProtocol {
    var isCategoryChoosed: Binding<Bool>? { get set }
    var isCategoryDeleted: Binding<IndexPath>? { get set }
    var isCategoryAdded: Binding<Bool>? { get set }
    
    func didChooseCategory(name category: String)
    var categories: [String] { get }
    func deleteCategory(at index: IndexPath)
    var chosenCategory: String { get }
    func addCategory(newCategory: String)
}

final class CategoryViewModel: CategoryViewModelProtocol {
    
    // MARK: - Свойства
    var isCategoryChoosed: Binding<Bool>?
    
    var isCategoryDeleted: Binding<IndexPath>?
    
    var isCategoryAdded: Binding<Bool>?
    
    private var model = TrackerCategoryStore()
    
    // MARK: - Методы
    func didChooseCategory(name category: String) {
        let result = model.changeChosenCategory(category: category)
        isCategoryChoosed?(result)
    }
    
    var categories: [String] {
        return model.savedCategories
    }
    
    func deleteCategory(at index: IndexPath) {
        let result = model.deleteCategory(at: index)
        isCategoryDeleted?(result)
    }
    
    var chosenCategory: String {
        return model.getChosenCategory()
    }
    
    func addCategory(newCategory: String) {
        let result = model.addCategory(newCategory: newCategory)
        isCategoryAdded?(result)
    }
}
