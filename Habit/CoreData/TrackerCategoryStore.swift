//
//  TrackerCategoryStore.swift
//  Habit
//
//  Created by Denis on 14.06.2023.
//

import Foundation
import CoreData

final class TrackerCategoryStore {
    
    private var categories = UserDefaults.standard.array(forKey: "category_list") as? [String]
    
    private var categoryName = ""
    
    // MARK: - Методы
    func changeChoosedCategory(category: String) -> Bool {
        categoryName = category
        return true
    }
    
    func getCategories() -> [String] {
        return categories ?? []
    }
    
    func deleteCategory(at index: IndexPath) -> IndexPath {
        categories?.remove(at: index.row)
        UserDefaults.standard.set(categories, forKey: "category_list")
        return index
    }
    
    func getChoosedCategory() -> String {
        return categoryName
    }
    
    // метод, добавляющий категорию в БД
    func addCategory(newCategory: String) -> Bool {
        categories?.append(newCategory)
        UserDefaults.standard.set(categories, forKey: "category_list")
        if UserDefaults.standard.synchronize() {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - метод, добавляющий структуру в БД
    func addCategoryStruct(category: String, tracker: TrackerCoreData, context: NSManagedObjectContext) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        
        var trackerCategories: [TrackerCategoryCoreData] = []
        do {
            trackerCategories = try context.fetch(request)
        } catch let error {
            print("Fetch error: \(error)")
            return
        }
        
        if let existingCategory = trackerCategories.first(where: { $0.name == category }) {
            existingCategory.addToTrackers(tracker)
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.name = category
            newCategory.id = UUID()
            newCategory.addToTrackers(tracker)
        }
        
        do {
            try context.save()
        } catch let error {
            print("Save error: \(error)")
        }
    }
    
}
