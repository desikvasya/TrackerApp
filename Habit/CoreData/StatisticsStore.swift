//
//  StatisticsStore.swift
//  Habit
//
//  Created by Denis on 20.07.2023.
//

import UIKit
import CoreData

/// Класс для работы с БД (статистика)
final class StatisticsStore: NSObject {
    
    // MARK: - Свойства
    
    let context: NSManagedObjectContext
    
    // MARK: - Методы
    
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    /// Метод для получения статистики
    func getStatistics() -> Int {
        let statisticsRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        do {
            let result = try context.fetch(statisticsRequest).count
            return result
        } catch {
            return 0
        }
    }
}
