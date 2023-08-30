//
//  AnalyticService.swift
//  Habit
//
//  Created by Denis on 20.07.2023.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    
    func report(event: String, params: [AnyHashable : Any]) {
        print(params)
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { (error) in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
}
