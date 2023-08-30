//
//  HabitTests1.swift
//  HabitTests1
//
//  Created by Denis on 18.07.2023.
//

import XCTest
import SnapshotTesting
@testable import Habit

final class TrackerTests: XCTestCase {
    
    func testMyViewController() {
        let vc = MainTabBarViewController()
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
}
