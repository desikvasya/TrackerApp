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
        let pinnedTrackerRequest = NSFetchRequest<PinnedTrackers>(entityName: "PinnedTrackers")
        pinnedTrackerRequest.predicate = NSPredicate(format: "pinnedTrackerID == %@", id.uuidString)

        do {
            let existingPinnedTracker = try context.fetch(pinnedTrackerRequest).first

            if existingPinnedTracker != nil {
                return
            }

            let newPinnedTracker = PinnedTrackers(context: context)
            newPinnedTracker.pinnedTrackerID = id
            newPinnedTracker.pinnedTrackerCategory = oldCategory

            let eventRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
            eventRequest.predicate = NSPredicate(format: "trackerID == %@", id.uuidString)

            do {
                let event = try context.fetch(eventRequest).first
                let categoryRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
                categoryRequest.predicate = NSPredicate(format: "name == %@", "Закреплённые")
                let category = try context.fetch(categoryRequest).first ?? TrackerCategoryCoreData(context: context)
                category.name = "Закреплённые"
//                category.name = NSLocalizedString("TrackersViewController.pinned", comment: "")

                event?.category = category
                try context.save()
            } catch {
                print("Не удалось закрепить трекер")
            }
        } catch {
            print("Не удалось проверить закрепление трекера")
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
    
//     Метод редактирования трекера

    func editEvent(id: UUID, event: Event, category: String, context: NSManagedObjectContext) {
        let eventRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        eventRequest.predicate = NSPredicate(format: "trackerID == %@", id.uuidString)
        do {
            let eventResult = try context.fetch(eventRequest).first
            let color = UIColor.hexString(from: event.color)
            eventResult?.color = color
            let day = event.day?.joined(separator: " ")
            eventResult?.day = day
            let emoji = event.emoji
            eventResult?.emoji = emoji
            let name = event.name
            eventResult?.name = name
            let categoryRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
            categoryRequest.predicate = NSPredicate(format: "name == %@", category)
            var categoryResult = try context.fetch(categoryRequest).first
            if categoryResult == nil {
                categoryResult = TrackerCategoryCoreData(context: context)
                categoryResult?.name = category
            }
            eventResult?.category = categoryResult
            try context.save()
        } catch {
            print("Не удалось отредактировать трекер")
        }
    }

    
}
