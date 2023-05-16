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
    
    var notificationsPublisher: PassthroughSubject<Bool, Never>? { get }
    func shouldRefreshListener<T: NSManagedObject>(notification: Notification, type: T.Type)
}

extension NotifiableDataSource {
    func shouldRefreshListener<T: NSManagedObject>(notification: Notification, type: T.Type) {
        let inserted = notification.insertedObjects
        let deleted = notification.deletedObjects
        let updated = notification.updatedObjects
        
        let shouldRefreshMyLists = checkForDataChanges(myType: type, list: inserted)  || checkForDataChanges(myType: type, list: updated) || checkForDataChanges(myType: type, list: deleted)
        
        if shouldRefreshMyLists {
            notificationsPublisher?.send(true)
        }
        
    }
    
    func checkForDataChanges<T: NSManagedObject>(myType: T.Type, list: Set<NSManagedObject>?) -> Bool {
        return list?.contains(where: { $0 is T }) ?? false
    }
}
