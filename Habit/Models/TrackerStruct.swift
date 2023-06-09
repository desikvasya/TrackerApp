//
//  TrackerStruct.swift
//  TrackerApp
//
//  Created by Denis on 29.05.2023.
//

import UIKit

// Структура для создания объектов событий (привычек или нерегулярных событий)
struct Event {
    
    // MARK: - Свойства
    let id: UUID
    var name: String
    var emoji: String
    var color: UIColor
    var day: [String]?
    
    // MARK: - Инициализатор
    init(id: UUID = UUID(), name: String, emoji: String, color: UIColor, day: [String]?) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
        self.day = day
    }
}

struct TrackerCategory {
    
    // MARK: - Свойства
    let label: String
    let trackers: [Event]
    
    // MARK: - Инициализатор
    init(label: String, trackers: [Event]) {
        self.label = label
        self.trackers = trackers
    }
}

struct TrackerRecord {
    
    // MARK: - Свойства
    let id: UUID
    var day: String
    
    // MARK: - Инициализатор
    init(id: UUID, day: String) {
        self.id = id
        self.day = day
    }
}
