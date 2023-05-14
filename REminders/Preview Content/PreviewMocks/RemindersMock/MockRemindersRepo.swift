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
        return ReminderData(id: UUID(), title: "reminder 1", notes: "notes...", list: MockMyListData.getList1())
    }
    
    static func getReminder2() -> ReminderData {
        return ReminderData(id: UUID(), title: "reminder 2", notes: "notes 2...", list: MockMyListData.getList2())
    }
}

struct MockRemindersRepo: ReminderRepository {
    var notificationsPublisher = PassthroughSubject<Bool, Never>()
    
    func getReminders() async -> Result<[ReminderData], DataSourceError> {
        return .success([MockRemindersData.getReminder1(), MockRemindersData.getReminder2()])
    }
    
    func getRemindersByListId(_ id: UUID) async -> Result<[ReminderData], DataSourceError> {
        return .success([MockRemindersData.getReminder1()])
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
