//
//  AddReminderViewModel.swift
//  REminders
//
//  Created by Selma Suvalija on 5/13/23.
//

import Foundation
import Factory

class AddReminderViewModel: ObservableObject {
    enum AddReminderState: Equatable {
        case loading
        case created
        case error(_ message: String)
    }
    
    @Injected(\.remindersRepo) private var remindersRepo: ReminderRepository
    @Published var state: AddReminderState = .loading
    
    @MainActor
    func createReminder(title: String, list: MyListData) async {
        let result = await remindersRepo.createReminder(ReminderData(id: UUID(), title: title, notes: "", list: list))
        
        switch result {
        case .success:
            state = .created
        case .failure:
            state = .error("Failed to create reminder with title \(title)")
        }
    }
}
