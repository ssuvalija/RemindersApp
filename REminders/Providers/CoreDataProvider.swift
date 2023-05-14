//
//  CoreDataProvider.swift
//  REminders
//
//  Created by Selma Suvalija on 4/25/23.
//

import Foundation
import CoreData

class CoreDataProvider {
    static let shared = CoreDataProvider()
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    var notificationsPublisher: NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
    }
    
    private init() {
        //register transformers
        
        UIColorTransformer.register()
        
        persistentContainer = NSPersistentContainer(name: "RemindersModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Error initializing RemindersModel \(error)")
            }
        }
        context = persistentContainer.viewContext
    }
    
//    func listenForUpdateNotifications() {
//        NotificationCenter.default.publisher(for: NSNotification.Name.NSManagedObjectContextDidSave, object: context).sink(receiveValue: { notification in
//            let inserted = notification.insertedObjects
//            let deleted = notification.deletedObjects
//            let updated = notification.updatedObjects
//
//             for ob in inserted! {
//               print(ob)
//             }
//
//        }).store(in: &cancelable)
//    }
}
