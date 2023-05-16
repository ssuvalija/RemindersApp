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
    @Injected(\.remindersRepo) private var remindersRepo: ReminderRepository

    @Published var state: RemindersListState = .loading
    @Published var reminders: [ReminderData] = []
    @Published var showDeletedReminderToast = false
    private var cancellables = Set<AnyCancellable>()

    var listID: UUID?
    var searchTerm: String?
    var type: ReminderListViewType = .listReminders
    
    init() {
       subscribeForDataUpdatesNotifications()
    }
    
    @MainActor
    func load() async {
        
        var result: Result<[ReminderData], DataSourceError>? = nil
        
        switch type {
        case .listReminders:
            guard let listID = listID else {
                state = .error("List ID can't be empty")
                return
            }
            result = await remindersRepo.getRemindersByListId(listID)
        case .all:
            result = await remindersRepo.getReminders()
        case .todays:
            result = await remindersRepo.getRemindersForToday()
        case .scheduled:
            result = await remindersRepo.getScheduledReminders()
        case .completed:
            result = await remindersRepo.getCompletedReminders()
        case .search:
            result = await remindersRepo.getBySearchTerm(searchTerm ?? "")
        }
        
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
        case .none:
            state = .error("Error happened while loading reminders")
        }
    }
    
    @MainActor
    func deleteReminderWith(id: UUID) async {
        let result = await remindersRepo.deleteReminder(id)
        switch result {
        case .success(let res):
            if res == true {
                showDeletedReminderToast = true
            } else {
                state = .error("Error occured while deleting the reminder")
            }
        case .failure(_):
            state = .error("Error occured while deleting the reminder")
        }
    }
    
    @MainActor
    func updateReminder(_ reminder: ReminderData) async {
        
        let result = await remindersRepo.updateReminder(reminder)
        
        switch result {
        case .success(let success):
            if success != true {
                state = .error("Error occured while updating reminder")
            }
        case .failure(_):
            state = .error("Error occured while updating reminder")
         }
    }
    
    private func subscribeForDataUpdatesNotifications() {
        remindersRepo.notificationsPublisher?.sink { [weak self] shouldUpdate in
            if shouldUpdate {
                Task { [weak self] in
                    await self?.load()
                }
            }
        }.store(in: &cancellables)
    }
    
    deinit {
        print("reminders view model deint called -----------")
    }
    
}
