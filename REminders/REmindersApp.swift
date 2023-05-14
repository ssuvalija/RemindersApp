//
//  REmindersApp.swift
//  REminders
//
//  Created by Selma Suvalija on 4/25/23.
//

import SwiftUI
import UserNotifications

@main
struct REmindersApp: App {
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                
            } else {
                
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
        }
    }
}
