//
//  MyList+CoreDataClass.swift
//  REminders
//
//  Created by Selma Suvalija on 4/25/23.
//

import Foundation
import CoreData

@objc(MyList)
public class MyList: NSManagedObject {
    var remindersArray: [Reminder] {
        reminders?.allObjects.compactMap { ($0 as! Reminder) } ?? []
    }
}
