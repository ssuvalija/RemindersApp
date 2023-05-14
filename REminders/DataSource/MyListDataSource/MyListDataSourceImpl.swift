//
//  MyListDataSourceImpl.swift
//  REminders
//
//  Created by Selma Suvalija on 5/4/23.
//

import Foundation
import CoreData
import Combine

class MyListDataSourceImpl: MyListDataSource, NotifiableDataSource {
    
    var container: NSPersistentContainer = CoreDataProvider.shared.persistentContainer
    var context: NSManagedObjectContext = CoreDataProvider.shared.persistentContainer.viewContext
    var cancelables = Set<AnyCancellable>()
    var notificationsPublisher = PassthroughSubject<Bool, Never>()
    
    init() {
        listenForUpdateNotifications()
    }
    
    func getAll() async throws -> [MyListEntity] {
        let request = MyListEntity.fetchRequest()
        return try context.fetch(request)
    }
    
    func getById(_ id: UUID) async throws -> MyListEntity? {
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
    
    func create(list: MyListData) async throws {
        let myListEntity = MyListEntity(context: context)
        myListEntity.id = list.id
        myListEntity.name = list.name
        myListEntity.color = list.color
        saveContext()
    }
    
    func update(id: UUID, list: MyListData) async throws {
        let myListEntity = try getEntityById(id)!
        myListEntity.name = list.name
        myListEntity.color = list.color
        saveContext()
    }
    
    private func getEntityById(_ id: UUID) throws -> MyListEntity? {
        let request = MyListEntity.fetchRequest()
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
    
    func listenForUpdateNotifications() {
        CoreDataProvider.shared.notificationsPublisher.sink { [weak self] notification in
            self?.shouldRefreshListener(notification: notification)
        }.store(in: &cancelables)
    }
    
}
