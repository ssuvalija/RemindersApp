//
//  MyListEntity+CoreDataProperties.swift
//  REminders
//
//  Created by Selma Suvalija on 5/4/23.
//
//

import Foundation
import CoreData
import UIKit

extension MyListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyListEntity> {
        return NSFetchRequest<MyListEntity>(entityName: "MyListEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var color: UIColor
    @NSManaged public var name: String
    @NSManaged public var reminders: NSSet?

}

// MARK: Generated accessors for reminders
extension MyListEntity {

    @objc(addRemindersObject:)
    @NSManaged public func addToReminders(_ value: ReminderEntity)

    @objc(removeRemindersObject:)
    @NSManaged public func removeFromReminders(_ value: ReminderEntity)

    @objc(addReminders:)
    @NSManaged public func addToReminders(_ values: NSSet)

    @objc(removeReminders:)
    @NSManaged public func removeFromReminders(_ values: NSSet)

}

extension MyListEntity : Identifiable {

}
