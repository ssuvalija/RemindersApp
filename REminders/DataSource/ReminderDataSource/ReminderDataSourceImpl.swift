//
//  ReminderDataSourceImpl.swift
//  REminders
//
//  Created by Selma Suvalija on 5/4/23.
//

import Foundation
import CoreData
import Combine
import Factory

class ReminderDataSourceImpl: ReminderDataSource, NotifiableDataSource {
    var container: NSPersistentContainer = CoreDataProvider.shared.persistentContainer
    var context: NSManagedObjectContext = CoreDataProvider.shared.persistentContainer.viewContext
    @Injected(\.myListDataSource) private var listDataSource: MyListDataSource
    var cancelables = Set<AnyCancellable>()
    var notificationsPublisher = PassthroughSubject<Bool, Never>()
    
    init() {
        listenForUpdateNotifications()
    }
    
    func getByListId(_ id: UUID) async throws -> [ReminderEntity] {
        let request = ReminderEntity.fetchRequest()
        let predicate = NSPredicate(format: "list.id = %@", id as CVarArg)
        request.predicate = predicate
        return try context.fetch(request)
    }
    
    func getAll() async throws -> [ReminderEntity] {
        let request = ReminderEntity.fetchRequest()
        return try context.fetch(request)
    }
    
    func getById(_ id: UUID) async throws -> ReminderEntity? {
        let entity = try getEntityById(id)
        return entity
    }
    
    func delete(_ id: UUID) async throws {
        let entity = try getEntityById(id)!
        context.delete(entity)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    func create(reminder: ReminderData) async throws {
        let reminderEntity = ReminderEntity(context: context)
        reminderEntity.id = reminder.id
        reminderEntity.title = reminder.title
        reminderEntity.isCompleted = reminder.isCompleted
        reminderEntity.notes = reminder.notes
        reminderEntity.reminderDate = reminder.reminderDate
        reminderEntity.reminderTime = reminder.reminderTime

        if let list = reminder.list {
            let listEntity = try await listDataSource.getById(list.id)
            reminderEntity.list = listEntity
        }
        
        //TODO: throw an error, reminder must be linked to an list
        
        saveContext()
    }
    
    func update(id: UUID, reminder: ReminderData) async throws {
        let reminderEntity = try getEntityById(id)
        reminderEntity?.title = reminder.title
        reminderEntity?.notes = reminder.notes
        reminderEntity?.isCompleted = reminder.isCompleted
        reminderEntity?.reminderTime = reminder.reminderTime
        reminderEntity?.reminderDate = reminder.reminderDate
        if let list = reminder.list {
            let listEntity = try await listDataSource.getById(list.id)
            reminderEntity?.list = listEntity
        }
        
        saveContext()
        
    }
    
    func listenForUpdateNotifications() {
        CoreDataProvider.shared.notificationsPublisher.sink { [weak self] notification in
            self?.shouldRefreshListener(notification: notification)
        }.store(in: &cancelables)
    }
    
    private func getEntityById(_ id: UUID) throws -> ReminderEntity? {
        let request = ReminderEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        let entity = try context.fetch(request)
        if !entity.isEmpty {
            return entity[0]
        }
        return nil
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error while saving data to DB")
            }
        }
    }
}
