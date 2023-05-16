//
//  Reminder.swift
//  REminders
//
//  Created by Selma Suvalija on 5/3/23.
//

import Foundation

struct ReminderData: Identifiable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var notes: String?
    var reminderDate: Date?
    var reminderTime: Date?
    var list: MyListData?
    
    var hasDate: Bool = false
    var hasTime: Bool = false
    
    init(reminder: ReminderEntity) {
        title = reminder.title ?? ""
        isCompleted = reminder.isCompleted
        notes = reminder.notes
        reminderDate = reminder.reminderDate
        reminderTime = reminder.reminderTime
        if let myList = reminder.list {
            list = MyListData(myList: myList)
        }
        id = reminder.id ?? UUID()
        
        hasDate = reminderDate != nil
        hasTime = reminderTime != nil
    }
    
    init(id: UUID, title: String, notes: String, list: MyListData) {
        self.id = id
        self.title = title
        self.notes = notes
        self.isCompleted = false
        self.reminderDate = nil
        self.reminderTime = nil
        self.list = list
    }
    
}
