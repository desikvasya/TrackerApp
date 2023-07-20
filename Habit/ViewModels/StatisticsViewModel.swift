//
//  StatisticsViewModel.swift
//  Habit
//
//  Created by Denis on 20.07.2023.
//

import Foundation

 /// VM для экрана статистики
 final class StatisticsViewModel {

     // MARK: - Свойства
     
     var isStatisticScreenShouldUpdate: Binding<Statistics>?

     let model = StatisticsStore()

     // MARK: - Методы
     
     /// Метод для получения статистики
     func getStatistics() {
         let result = Statistics(endedTracks: model.getStatistics())
         isStatisticScreenShouldUpdate?(result)
     }

 }
