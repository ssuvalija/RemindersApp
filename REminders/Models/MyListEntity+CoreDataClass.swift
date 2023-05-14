//
//  MyListEntity+CoreDataClass.swift
//  REminders
//
//  Created by Selma Suvalija on 5/4/23.
//
//

import Foundation
import CoreData

@objc(MyListEntity)
public class MyListEntity: NSManagedObject {
    var remindersArray: [ReminderEntity] {
        reminders?.allObjects.compactMap { ($0 as! ReminderEntity) } ?? []
    }
}
