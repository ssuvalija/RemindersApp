//
//  MyList.swift
//  REminders
//
//  Created by Selma Suvalija on 5/3/23.
//

import Foundation
import UIKit

struct MyListData: Identifiable, Hashable {
    static func == (lhs: MyListData, rhs: MyListData) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    var id: UUID
    var name: String
    var color: UIColor
    var reminders: [ReminderData]?
    
    init(myList: MyListEntity) {
        id = myList.id
        name = myList.name
        color = myList.color
        for reminder in myList.remindersArray {
            reminders?.append(ReminderData(reminder: reminder))
        }
    }
    
    init(id: UUID, name: String, color: UIColor) {
        self.id = id
        self.name = name
        self.color = color
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
