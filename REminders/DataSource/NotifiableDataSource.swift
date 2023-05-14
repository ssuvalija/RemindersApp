//
//  NotifiableDataSource.swift
//  REminders
//
//  Created by Selma Suvalija on 5/13/23.
//

import Foundation
import Combine
import CoreData

protocol NotifiableDataSource {
    
    var notificationsPublisher: PassthroughSubject<Bool, Never> { get }
    func shouldRefreshListener(notification: Notification)
}

extension NotifiableDataSource {
    func shouldRefreshListener(notification: Notification) {
        let inserted = notification.insertedObjects
        let deleted = notification.deletedObjects
        let updated = notification.updatedObjects
        
        var shouldRefreshMyLists = checkForDataChanges(myType: MyListEntity.self, list: inserted)  || checkForDataChanges(myType: MyListEntity.self, list: updated) || checkForDataChanges(myType: MyListEntity.self, list: deleted)
        
        if shouldRefreshMyLists {
            notificationsPublisher.send(true)
        }
        
    }
    
    func checkForDataChanges<T: NSManagedObject>(myType: T.Type, list: Set<NSManagedObject>?) -> Bool {
        return list?.contains(where: { $0 is T }) ?? false
    }
}
