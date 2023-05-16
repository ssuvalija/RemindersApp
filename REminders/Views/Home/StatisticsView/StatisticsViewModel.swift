//
//  StatisticsViewModel.swift
//  REminders
//
//  Created by Selma Suvalija on 5/16/23.
//

import Foundation
import Factory

class StatisticsViewModel: ObservableObject {
    @Injected(\.remindersRepo) private var remindersRepo: ReminderRepository
    
    @Published var todayCount: Int = 0
    @Published var scheduledCount: Int = 0
    @Published var allCount: Int = 0
    @Published var completedCount: Int = 0
    
    @MainActor
    func calculateStatistics() async {
        let remindersResult = await remindersRepo.getReminders()
        
        switch remindersResult {
        case .success(let remindersArray):
            todayCount = calculateTodaysCount(reminders: remindersArray)
            scheduledCount = calculateScheduledCount(reminders: remindersArray)
            allCount = calculateAllCount(reminders: remindersArray)
            completedCount = calculateCompletedCount(reminders: remindersArray)
        case .failure(_):
            print("error")
        }
        
    }
    
    private func calculateTodaysCount(reminders: [ReminderData]) -> Int {
        return reminders.reduce(0) { result, reminder in
            let isToday = reminder.reminderDate?.isToday ?? false
            return isToday ? result + 1 : result
        }
    }
    
    private func calculateAllCount(reminders: [ReminderData]) -> Int {
        return reminders.reduce(0) { result, reminder in
            return !reminder.isCompleted ? result + 1 : result
        }
    }
    
    private func calculateCompletedCount(reminders: [ReminderData]) -> Int {
        return reminders.reduce(0) { result, reminder in
            return reminder.isCompleted ? result + 1 : result
        }
    }
    
    private func calculateScheduledCount(reminders: [ReminderData]) -> Int {
        return reminders.reduce(0) { result, reminder in
            return ((reminder.reminderDate != nil || reminder.reminderTime != nil) && !reminder.isCompleted) ? result + 1 : result
        }
    }
    
}


enum ReminderStatType {
    case all
    case today
    case scheduled
    case completed
}

struct ReminderStatsValues {
    var todayCount: Int = 0
    var scheduledCount: Int = 0
    var allCount: Int = 0
    var completedCount: Int = 0
    
}


