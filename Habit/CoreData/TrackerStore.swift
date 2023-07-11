//
//  TrackerStore.swift
//  Habit
//
//  Created by Denis on 14.06.2023.
//

import Foundation
import CoreData
import UIKit

final class TrackerStore {
    
    // MARK: - Метод, добавляющий новый трекер из БД
    func addTracker(event: Event, category: String, context: NSManagedObjectContext, trackerCategoryStore: TrackerCategoryStore) {
        let tracker = TrackerCoreData(context: context)
        tracker.trackerID = event.id
        tracker.color = UIColor.hexString(from: event.color)
        tracker.day = event.day?.joined(separator: " ")
        tracker.emoji = event.emoji
        tracker.name = event.name
        do {
            try context.save()
        } catch {
            print("failed to save")
        }
        trackerCategoryStore.addCategoryStruct(category: category, tracker: tracker, context: context)
    }
    
    
    // MARK: - Метод, удаляющий трекер из БД
    func deleteTracker(id inID: UUID, context: NSManagedObjectContext) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "DataModel")
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: " %K == %@", #keyPath(TrackerCoreData.trackerID), inID.uuidString)
        request.predicate = predicate
        var result: [TrackerCoreData] = []
        do {
            result = try context.fetch(request)
        } catch {
            print("failed to fetch")
        }
        context.delete(result.first ?? TrackerCoreData())
        do {
            try context.save()
        } catch {
            print("failed to save")
        }
    }
}
