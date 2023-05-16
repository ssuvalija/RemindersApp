//
//  ReminderDataSource.swift
//  REminders
//
//  Created by Selma Suvalija on 5/4/23.
//

import Foundation
import Combine

protocol ReminderDataSource: AnyObject {
    var notificationsPublisher: PassthroughSubject<Bool, Never>? { get }
    func getAll() async throws -> [ReminderEntity]
    func getByListId(_ id: UUID) async throws -> [ReminderEntity]
    func getById(_ id: UUID) async throws -> ReminderEntity?
    func delete(_ id: UUID) async throws -> ()
    func create(reminder: ReminderData) async throws -> ()
    func update(id: UUID, reminder: ReminderData) async throws -> ()
    func getRemindersForToday() async throws -> [ReminderEntity]
    func getCompleted() async throws -> [ReminderEntity]
    func getScheduled() async throws -> [ReminderEntity]
    func getBySearchTerm(_ searchTerm: String) async throws -> [ReminderEntity]
}
