//
//  RemindersListViewModel.swift
//  REminders
//
//  Created by Selma Suvalija on 5/9/23.
//

import Foundation
import Combine
import Factory

enum RemindersListState {
    case loading
    case loaded(_ reminders: [ReminderData])
    case empty(_ message: String)
    case error(_ message: String)
}

class RemindersListViewModel: ObservableObject {
    @Published var state: RemindersListState = .loading
    @Published var reminders: [ReminderData] = []
    @Injected(\.remindersRepo) private var remindersRepo: ReminderRepository
    var listID: UUID?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        subscribeForDataUpdatesNotifications()
    }
    
    @MainActor
    func load() async {
        guard let listID = listID else {
            state = .error("List ID can't be empty")
            return
        }
        
        let result = await remindersRepo.getRemindersByListId(listID)
        switch result {
        case .success(let data):
            if data.isEmpty {
                state = .empty("No reminders found")
            } else {
                print("Got reminders \(data)")
                state = .loaded(data)
                reminders = data
            }
        case .failure(_):
            state = .error("Error happened while loading reminders")
        }
    }
    
    private func subscribeForDataUpdatesNotifications() {
        remindersRepo.notificationsPublisher.sink { shouldUpdate in
            if shouldUpdate {
                Task {
                    await self.load()
                }
            }
        }.store(in: &cancellables)
    }
}
