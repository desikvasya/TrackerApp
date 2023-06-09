//
//  TrackerRecordStore.swift
//  Habit
//
//  Created by Denis on 14.06.2023.
//

import Foundation
import CoreData

final class TrackerRecordStore {
    
    // MARK: - Метод, добавляющий +1 к счётчику выполненных трекеров
    func addRecord(id: UUID, day: String, context: NSManagedObjectContext) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        var trackers: [TrackerCoreData] = []
        do {
            trackers = try context.fetch(request)
        } catch _ {
            print("failed to fetch")
        }
        let newRecord = TrackerRecordCoreData(context: context)
        newRecord.day = day
        newRecord.tracker = trackers.filter({$0.trackerID == id}).first
        do {
            try context.save()
        } catch {
            print("failed to save")
        }
    }
    
    // MARK: - Метод, снимающий -1 от счётчика трекеров
    func deleteRecord(id: UUID, day: String, context: NSManagedObjectContext) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        var records: [TrackerRecordCoreData] = []
        do {
            records = try context.fetch(request)
        } catch _ {
            print("failed to fetch")
        }
        context.delete(records.filter({$0.tracker?.trackerID == id && $0.day == day}).first ?? NSManagedObject())
        do {
            try context.save()
        } catch {
            print("failed to save")
        }
    }
}
