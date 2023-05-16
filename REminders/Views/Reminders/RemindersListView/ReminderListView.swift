//
//  ReminderListView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/27/23.
//

import SwiftUI
import Combine
import Factory

enum ReminderListViewType {
    case listReminders
    case all
    case todays
    case scheduled
    case completed
    case search
}

struct ReminderListView: View {
    @EnvironmentObject private var coordinator: Coordinator<RemindersRouter>
    
    @Injected(\.remindersRepo) private var remindersRepo: ReminderRepository
    
    @StateObject var viewModel: RemindersListViewModel = RemindersListViewModel()
    @State private var selectedReminder: ReminderData?
    @State var myList: MyListData?
    @State var type: ReminderListViewType
    var searchTerm: Binding<String>? = nil
    
    private func reminderCheckedChanged(reminder: ReminderData, checked: Bool) {
        var updatedReminder = reminder
        updatedReminder.isCompleted = checked
        Task {
            await viewModel.updateReminder(updatedReminder)
        }
    }
    
    private func isReminderSelected(_ reminder: ReminderData) -> Bool {
        selectedReminder?.id == reminder.id
    }
    
    private func deleteReminder(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let reminder = viewModel.reminders[index]
            Task {
                await viewModel.deleteReminderWith(id:reminder.id)
            }
        }
    }
    
    
    var body: some View {
        Group {
            if viewModel.showDeletedReminderToast == true {
                withAnimation(Animation.spring().speed(1.5)) {
                    FancyToastView(type: .success, title: "Info", message: "Succefully deleted reminder", onCancelTapped: {})
                }
            }
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .error(let message):
                FancyToastView(type: .error, title: "Error", message: message, onCancelTapped: {})
            case .empty(let message):
                Text(message)
            case .loaded(let reminders):
                VStack {
                    List {
                        ForEach(reminders) { reminder in
                            ReminderCellView(reminder: reminder, isSelected: isReminderSelected(reminder)) { event in
                                switch event {
                                case .onInfo:
                                    if let reminder = selectedReminder {
                                        coordinator.show(.reminderDetails(reminder, onDismiss: {
                                            selectedReminder = nil
                                        }))
                                    }
                                case .onSelect(let reminder):
                                    selectedReminder = reminder
                                case .onCheckedChange(let reminder, let checked):
                                    reminderCheckedChanged(reminder: reminder, checked: checked)
                                }
                            }
                        }.onDelete(perform: deleteReminder)
                    }
                }
            }
        }.onAppear {
            loadData()
        }.onChange(of: searchTerm?.wrappedValue, perform: {newValue in
            viewModel.searchTerm = searchTerm?.wrappedValue
            loadData()
        })
        
    }
    
    func loadData() {
        viewModel.listID = myList?.id
        viewModel.type = self.type
        Task {
            await viewModel.load()
        }
    }
}

struct ReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.shared.remindersRepo.register { MockRemindersRepo() }
        ReminderListView(myList: MockMyListData.getList1(), type: .listReminders, searchTerm: .constant(""))
    }
}
