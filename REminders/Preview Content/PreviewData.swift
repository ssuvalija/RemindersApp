//
//  PreviewData.swift
//  REminders
//
//  Created by Selma Suvalija on 4/27/23.
//

import Foundation
import CoreData

class PreviewData {
    static var myList: MyList {
        let viewContext = CoreDataProvider.shared.persistentContainer.viewContext
        let myList = MyList(context: viewContext)
        myList.name = "My Red list"
        myList.color = .red
        //return (try? viewContext.fetch(request).first) ?? MyList(context: viewContext)
        return myList
    }
    
    static var reminder: Reminder {
        let viewContext = CoreDataProvider.shared.persistentContainer.viewContext
        let reminder = Reminder(context: viewContext)
        reminder.title = "reminder title"
        reminder.notes = "some notes goes here..."
        return reminder
        //let request = Reminder.fetchRequest()
        //return (try? viewContext.fetch(request).first) ?? Reminder(context: viewContext)
    }
}
