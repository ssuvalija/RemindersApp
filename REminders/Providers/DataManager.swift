//
//  DataManager.swift
//  REminders
//
//  Created by Selma Suvalija on 5/3/23.
//

import Foundation
import CoreData

protocol DataManager {
    
}

class CoreDataManager: DataManager {
    
    private var persistentContainer: NSPersistentContainer
    private var managedObjectContext: NSManagedObjectContext
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "RemindersModel")
        managedObjectContext = persistentContainer.viewContext
        
        configureDefaults(inMemory ,container: persistentContainer)
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
            
        }
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveReminder(reminderModel: ReminderData) {
//        let list = managedObjectContext.object(with: <#T##NSManagedObjectID#>)
//        var reminder = Reminder(context: managedObjectContext)
//        reminder.title = reminderModel.title
//        reminder.list = 
    }
    
    private func configureDefaults(_ inMemory: Bool = false, container: NSPersistentContainer) {
        if let storeDescription = container.persistentStoreDescriptions.first {
        storeDescription.shouldAddStoreAsynchronously = true
        if inMemory {
          storeDescription.url = URL(fileURLWithPath: "/dev/null")
          storeDescription.shouldAddStoreAsynchronously = false
        }
      }
    }
}
