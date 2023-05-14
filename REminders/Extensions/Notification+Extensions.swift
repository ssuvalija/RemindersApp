//
//  Notification+Extensions.swift
//  REminders
//
//  Created by Selma Suvalija on 5/8/23.
//

import Foundation
import CoreData

extension Notification {
    var insertedObjects: Set<NSManagedObject>? {
        return userInfo?.value(for: .insertedObjects)
    }
    
    var updatedObjects: Set<NSManagedObject>? {
        return userInfo?.value(for: .updatedObjects)
    }
    
    var deletedObjects: Set<NSManagedObject>? {
      return userInfo?.value(for: .deletedObjects)
    }
}
