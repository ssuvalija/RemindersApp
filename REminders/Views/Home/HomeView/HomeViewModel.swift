//
//  HomeViewModel.swift
//  REminders
//
//  Created by Selma Suvalija on 5/17/23.
//

import Foundation
import Factory

enum HomeViewModelState {
    case loading
    case loaded([ReminderData])
    case error(String)
}

class HomeViewModel: ObservableObject {
    @Injected(\.remindersRepo) private var remindersRepo: ReminderRepository
    @Published var state: HomeViewModelState = .loading
    
    @MainActor
    func searchForRemindersBy(searchTerm: String) async {
        let result = await remindersRepo.getBySearchTerm(searchTerm)
        
        switch result {
        case .success(let data):
            state = .loaded(data)
        case .failure(_):
            state = .error("Error occured while searching for reminders by keyword: \(searchTerm)")
        }
    }
}
