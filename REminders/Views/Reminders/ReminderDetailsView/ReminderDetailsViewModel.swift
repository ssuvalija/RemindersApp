//
//  ReminderDetailsViewModel.swift
//  REminders
//
//  Created by Selma Suvalija on 5/15/23.
//

import Foundation
import Combine
import Factory

enum ReminderDetailsViewState {
    case loading
    case loaded
    case error(String)
}

class ReminderDetailsViewModel: ObservableObject {
    @Injected(\.remindersRepo) private var remindersRepo
    @Published var state: ReminderDetailsViewState = .loading
    @Published var reminder: ReminderData
    
    init(reminder: ReminderData) {
        self.reminder = reminder
    }
    
    @MainActor
    func updateReminder() async {
        let result = await remindersRepo.updateReminder(reminder)
        
        switch result {
        case .success(let success):
            if success {
                state = .loaded
            } else {
                state = .error("Error occured while updating reminder")
            }
        case .failure(_):
            state = .error("Error occured while updating reminder")
        }
    }
    
    func hasDateChanged(hasDate: Bool) {
        if hasDate == true {
            reminder.reminderDate = Date()
        } else {
            reminder.reminderDate = nil
        }
    }
    
    func hasTimeChanged(hasTime: Bool) {
        if hasTime == true {
            reminder.reminderTime = Date()
        } else {
            reminder.reminderTime = nil
        }
    }
    
    deinit {
        print("reminders details view model deint called -----------")
    }
}
