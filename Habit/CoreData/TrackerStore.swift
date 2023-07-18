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
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
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
    
    // MARK: - методы закрепления/открепления трекеров

    func pinEvent(oldCategory: String, id: UUID, context: NSManagedObjectContext) {
        let pinnedTracker = PinnedTrackers(context: context)
        pinnedTracker.pinnedTrackerID = id
        pinnedTracker.pinnedTrackerCategory = oldCategory
        let eventRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        eventRequest.predicate = NSPredicate(format: "trackerID == %@", id.uuidString)
        do {
            let event = try context.fetch(eventRequest).first
            let category = TrackerCategoryCoreData(context: context)
            category.name = "Закреплённые"
            event?.category = category
            try context.save()
        } catch {
            print("Не удалось закрепить трекер")
        }
    }

    
    func unpinEvent(id: UUID, context: NSManagedObjectContext) -> String {
        let request = NSFetchRequest<PinnedTrackers>(entityName: "PinnedTrackers")
        request.predicate = NSPredicate(format: "pinnedTrackerID == %@", id.uuidString)
        do {
            guard let result = try context.fetch(request).first?.pinnedTrackerCategory else { return "" }
            let eventRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
            eventRequest.predicate = NSPredicate(format: "trackerID == %@", id.uuidString)
            let event = try context.fetch(eventRequest).first
            let categoryRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
            categoryRequest.predicate = NSPredicate(format: "name == %@", result)
            let category = try context.fetch(categoryRequest).first
            event?.category = category
            context.delete(try context.fetch(request).first ?? PinnedTrackers())
            try context.save()
            return result
        } catch {
            print("Не удалось открепить трекер")
        }
        return ""
    }
    
    func isTrackerPinned(id: UUID, context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest<PinnedTrackers>(entityName: "PinnedTrackers")
        request.predicate = NSPredicate(format: "pinnedTrackerID == %@", id.uuidString)
        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            print("Failed to fetch pinned trackers")
        }
        return false
    }


}
