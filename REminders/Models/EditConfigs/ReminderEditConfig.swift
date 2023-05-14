//
//  ReminderEditConfig.swift
//  REminders
//
//  Created by Selma Suvalija on 4/28/23.
//

import Foundation

struct ReminderEditConfig {
    var title: String = ""
    var notes: String?
    var isCompleted: Bool = false
    var hasDate: Bool = false
    var hasTime: Bool = false
    var reminderDate: Date?
    var reminderTime: Date?
    
    init() { }
    
    init(reminder: Reminder) {
        title = reminder.title ?? ""
        notes = reminder.notes
        isCompleted = reminder.isCompleted
        hasDate = reminder.reminderDate != nil
        hasTime = reminder.reminderTime != nil
        reminderTime = reminder.reminderTime
        reminderDate = reminder.reminderDate
    }
}
