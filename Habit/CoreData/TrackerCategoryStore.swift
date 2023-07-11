//
//  TrackerCategoryStore.swift
//  Habit
//
//  Created by Denis on 14.06.2023.
//

import Foundation
import CoreData

final class TrackerCategoryStore {
    
    private var categories = [
        "Важное", "Домашние дела", "Работа", "Учёба", "Спорт"
     ]

     private var categoryName = ""

     // MARK: - Методы
     func changeChoosedCategory(category: String) -> Bool {
         categoryName = category
         return true
     }

     func getCategories() -> [String] {
         return categories
     }

     func deleteCategory(at index: IndexPath) -> IndexPath {
         categories.remove(at: index.row)
         return index
     }

     func getChoosedCategory() -> String {
         return categoryName
     }

    
    
    // MARK: - Method to add a category in the database
    func addCategory(category: String, tracker: TrackerCoreData, context: NSManagedObjectContext) {
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
