//
//  DataProvider.swift
//  Habit
//
//  Created by Denis on 14.06.2023.
//

import CoreData
import UIKit

final class DataProvider: NSObject {
    
    let appDelegate: AppDelegate
    
    let context: NSManagedObjectContext
    
    weak var delegate: TrackersViewController?
    
    let trackerStore = TrackerStore()
    
    let trackerCategoryStore = TrackerCategoryStore()
    
    let trackerRecordStore = TrackerRecordStore()
    
    lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    // MARK: - Инициализатор
    
    override init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Метод, добавляющий в БД новый трекер
    
    func addTracker(event: Event, category: String) {
        trackerStore.addTracker(event: event, category: category, context: context, trackerCategoryStore: trackerCategoryStore)
    }
    
    // MARK: - Метод, удаляющий трекер из БД
    
    func deleteTracker(id inID: UUID) {
        trackerStore.deleteTracker(id: inID, context: context)
    }
    
    // MARK: - Методы, закрепления/ открепления трекера

    func pinEvent(oldCategory: String, id: UUID) {
        trackerStore.pinEvent(oldCategory: oldCategory, id: id, context: context)
    }
    
    func unpinEvent(id: UUID) -> String {
        return trackerStore.unpinEvent(id: id, context: context)
    }
    
    func isTrackerPinned(id: UUID) -> Bool {
        return trackerStore.isTrackerPinned(id: id, context: context)
    }
    
    func editEvent(id: UUID, event: Event, category: String) {
        trackerStore.editEvent(id: id, event: event, category: category, context: context)
    }
    
    // MARK: - Метод, добавляющий +1 к счётчику выполненных трекеров
    func addRecord(id: UUID, day: String) {
        trackerRecordStore.addRecord(id: id, day: day, context: context)
    }
    
    // MARK: - Метод, снимающий -1 от счётчика трекеров
    func deleteRecord(id: UUID, day: String) {
        trackerRecordStore.deleteRecord(id: id, day: day, context: context)
    }
    
    // MARK: - Метод, обновляющий массивы, из которых UICollection берёт данные
    func updateCollectionView() {
        let categoryRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        categoryRequest.returnsObjectsAsFaults = false
        var trackerCategories: [TrackerCategoryCoreData] = []
        do {
            trackerCategories = try context.fetch(categoryRequest)
        } catch {
            print("failed to fetch")
        }
        let trackerRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        trackerRequest.returnsObjectsAsFaults = false
        var trackersCoreData: [TrackerCoreData] = []
        do {
            trackersCoreData = try context.fetch(trackerRequest)
        } catch {
            print("failed to fetch")
        }
        trackers = []
        trackerCategories.forEach { category in
            let newCategoryName = category.name
            var events: [Event] = []
            trackersCoreData.forEach { track in
                if track.category?.name == newCategoryName {
                    events.append(Event(id: track.trackerID ?? UUID(), name: track.name ?? "", emoji: track.emoji ?? "", color: UIColor.color(from: track.color ?? ""), day: track.day?.components(separatedBy: " ")))
                }
            }
            let newTrackersByCategory = [TrackerCategory(label: newCategoryName ?? "", trackers: events)]
            trackers.append(contentsOf: newTrackersByCategory.sorted(by: {$0.label > $1.label}))
        }
        trackerRecords = []
        let recordRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        recordRequest.returnsObjectsAsFaults = false
        var trackerRecordCoreData: [TrackerRecordCoreData] = []
        do {
            trackerRecordCoreData = try context.fetch(recordRequest)
        } catch {
            print("failed to fetch")
        }
        trackerRecordCoreData.forEach { record in
            trackerRecords.append(TrackerRecord(id: record.tracker?.trackerID ?? UUID(), day: record.day ?? ""))
        }
        delegate?.updateCollection()
        delegate?.updateCollectionView()
    }
    
}

// MARK: - Расширение для NSFetchedResultsControllerDelegate
extension DataProvider: NSFetchedResultsControllerDelegate {
    
    // MARK: Метод, вызываемый автоматически при изменении данных в БД
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        updateCollectionView()
        delegate?.datePickerValueChanged(sender: delegate?.datePicker ?? UIDatePicker())
    }
    
}
