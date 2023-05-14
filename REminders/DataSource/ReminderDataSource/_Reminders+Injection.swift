//
//  _ViewModels+Injection.swift
//  REminders
//
//  Created by Selma Suvalija on 5/10/23.
//

import Foundation
import Factory

extension Container {    
    var remindersDataSource: Factory<ReminderDataSource> {
        Factory(self) { ReminderDataSourceImpl() }
    }
    
    var remindersRepo: Factory<ReminderRepository> {
        Factory(self) { ReminderRepositoryImpl(dataSource: self.remindersDataSource()) }
    }
    
    var addReminderViewModel: Factory<AddReminderViewModel> {
        Factory(self) { AddReminderViewModel() } 
    }
}
