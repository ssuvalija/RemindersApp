//
//  ReminderRepository.swift
//  REminders
//
//  Created by Selma Suvalija on 5/9/23.
//

import Foundation
import Combine

protocol ReminderRepository {
    var notificationsPublisher: PassthroughSubject<Bool, Never> { get }
    func getReminders() async -> Result<[ReminderData], DataSourceError>
    func getRemindersByListId(_ id: UUID) async -> Result<[ReminderData], DataSourceError>
    func getReminder(id: UUID) async -> Result<ReminderData?, DataSourceError>
    func deleteReminder(_ id: UUID) async -> Result<Bool, DataSourceError>
    func createReminder(_ reminder: ReminderData) async -> Result<Bool, DataSourceError>
    func updateReminder(_ reminder: ReminderData) async -> Result<Bool, DataSourceError>
}
