//
//  Dictionary+Extensions.swift
//  REminders
//
//  Created by Selma Suvalija on 5/8/23.
//

import Foundation
import CoreData

extension Dictionary where Key == AnyHashable {
  func value<T>(for key: NSManagedObjectContext.NotificationKey) -> T? {
    return self[key.rawValue] as? T
  }
}
