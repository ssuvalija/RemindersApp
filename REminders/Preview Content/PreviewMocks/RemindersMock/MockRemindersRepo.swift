//
//  MockRemindersRepo.swift
//  REminders
//
//  Created by Selma Suvalija on 5/13/23.
//

import Foundation
import Combine

enum MockRemindersData {
    static func getReminder1() -> ReminderData {
        var reminder1 = ReminderData(id: UUID(), title: "reminder 1", notes: "notes...", list: MockMyListData.getList1())
        reminder1.reminderDate = Date()
        return reminder1
    }
    
    static func getReminder2() -> ReminderData {
        var reminder2 = ReminderData(id: UUID(), title: "reminder 2", notes: "notes 2...", list: MockMyListData.getList2())
        reminder2.reminderTime = Calendar.current.date(from: DateComponents(hour: Date().dateComponents.hour, minute: Date().dateComponents.minute))
        return reminder2
    }
    
    static func getReminder3() -> ReminderData {
        var reminder3 = ReminderData(id: UUID(), title: "reminder 3", notes: "notes 3...", list: MockMyListData.getList2())
        reminder3.isCompleted = true
        return reminder3
    }
    
    static func getReminder4() -> ReminderData {
        let reminder4 = ReminderData(id: UUID(), title: "reminder 4", notes: "notes 4...", list: MockMyListData.getList1())
        return reminder4
    }
}

struct MockRemindersRepo: ReminderRepository {
    var notificationsPublisher: PassthroughSubject<Bool, Never>?
    
    func getRemindersForToday() async -> Result<[ReminderData], DataSourceError> {
        return .success([MockRemindersData.getReminder1()])
    }
    
    func getCompletedReminders() async -> Result<[ReminderData], DataSourceError> {
        return .success([MockRemindersData.getReminder2()])
    }
    
    func getScheduledReminders() async -> Result<[ReminderData], DataSourceError> {
        return .success([MockRemindersData.getReminder1(), MockRemindersData.getReminder2()])
    }
    
    
    func getReminders() async -> Result<[ReminderData], DataSourceError> {
        return .success([MockRemindersData.getReminder1(), MockRemindersData.getReminder2(), MockRemindersData.getReminder3(), MockRemindersData.getReminder4()])
    }
    
    func getRemindersByListId(_ id: UUID) async -> Result<[ReminderData], DataSourceError> {
        return .success([MockRemindersData.getReminder1()])
    }
    
    func getBySearchTerm(_ searchTerm: String) async -> Result<[ReminderData], DataSourceError> {
        return .success([MockRemindersData.getReminder2()])
    }
    
    func getReminder(id: UUID) async -> Result<ReminderData?, DataSourceError> {
        return .success(MockRemindersData.getReminder2())
    }
    
    func deleteReminder(_ id: UUID) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
    
    func createReminder(_ reminder: ReminderData) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
    
    func updateReminder(_ reminder: ReminderData) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
    
}
