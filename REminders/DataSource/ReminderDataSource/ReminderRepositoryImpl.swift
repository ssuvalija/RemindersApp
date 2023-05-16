//
//  ReminderRepositoryImpl.swift
//  REminders
//
//  Created by Selma Suvalija on 5/9/23.
//

import Foundation
import Combine

class ReminderRepositoryImpl: ReminderRepository {    
    
    let dataSource: ReminderDataSource
    var notificationsPublisher: PassthroughSubject<Bool, Never>? {
        return dataSource.notificationsPublisher
    }
    
    
    init(dataSource: ReminderDataSource) {
        self.dataSource = dataSource
    }
    
    func getReminders() async -> Result<[ReminderData], DataSourceError> {
        do {
            let reminders = try await dataSource.getAll()
            return .success(reminders.map { reminder in
                ReminderData(reminder: reminder)
            })
        } catch {
            return .failure(.FetchError)
        }
    }
    
    func getRemindersForToday() async -> Result<[ReminderData], DataSourceError> {
        do {
            let reminders = try await dataSource.getRemindersForToday()
            return .success(reminders.map { reminder in
                ReminderData(reminder: reminder)
            })
        } catch {
            return .failure(.FetchError)
        }
    }
    
    func getCompletedReminders() async -> Result<[ReminderData], DataSourceError> {
        do {
            let reminders = try await dataSource.getCompleted()
            return .success(reminders.map { reminder in
                ReminderData(reminder: reminder)
            })
        } catch {
            return .failure(.FetchError)
        }
    }
    
    func getScheduledReminders() async -> Result<[ReminderData], DataSourceError> {
        do {
            let reminders = try await dataSource.getScheduled()
            return .success(reminders.map { reminder in
                ReminderData(reminder: reminder)
            })
        } catch {
            return .failure(.FetchError)
        }
    }
    
    func getRemindersByListId(_ id: UUID) async -> Result<[ReminderData], DataSourceError> {
        do {
            let reminders = try await dataSource.getByListId(id)
            return .success(reminders.map { reminder in
                ReminderData(reminder: reminder)
            })
        } catch {
            return .failure(.FetchError)
        }
    }
    
    func getBySearchTerm(_ searchTerm: String) async -> Result<[ReminderData], DataSourceError> {
        do {
            let reminders = try await dataSource.getBySearchTerm(searchTerm)
            return .success(reminders.map { reminder in
                ReminderData(reminder: reminder)
            })
        } catch {
            return .failure(.FetchError)
        }
    }
    
    func getReminder(id: UUID) async -> Result<ReminderData?, DataSourceError> {
        do {
            if let reminder = try await dataSource.getById(id) {
                return .success(ReminderData(reminder: reminder))
            } else {
                return .success(nil)
            }
        } catch {
            return .failure(.FetchError)
        }
    }
    
    func deleteReminder(_ id: UUID) async -> Result<Bool, DataSourceError> {
        do {
            try await dataSource.delete(id)
            return .success(true)
        } catch {
            return .failure(.DeleteError)
        }
    }
    
    func createReminder(_ reminder: ReminderData) async -> Result<Bool, DataSourceError> {
        do {
            try await dataSource.create(reminder: reminder)
            return .success(true)
        } catch {
            return .failure(.CreateError)
        }
    }
    
    func updateReminder(_ reminder: ReminderData) async -> Result<Bool, DataSourceError> {
        do {
            try await dataSource.update(id: reminder.id, reminder: reminder)
            return .success(true)
        } catch {
            return .failure(.UpdateError)
        }
    }

}
