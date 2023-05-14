//
//  ReminderListView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/27/23.
//

import SwiftUI
import Combine
import Factory

struct ReminderListView: View {
    @Injected(\.remindersRepo) private var remindersRepo: ReminderRepository
    
    @StateObject var viewModel: RemindersListViewModel = RemindersListViewModel()
    @State private var selectedReminder: ReminderData?
    @State private var showReminderDetail: Bool = false
    @State var cancellable: AnyCancellable?
    @State var myList: MyListData
    
    
    private func reminderCheckedChanged(reminder: ReminderData, checked: Bool) {
        //        var editConfig = ReminderEditConfig(reminder: reminder)
        //        editConfig.isCompleted = checked
        //        do {
        //            let _ = try ReminderService.updateReminder(reminder: reminder, editConfig: editConfig)
        //        } catch {
        //            assertionFailure("Failed to update reminder")
        //            print(error)
        //        }
    }
    
    private func isReminderSelected(_ reminder: ReminderData) -> Bool {
        selectedReminder?.id == reminder.id
    }
    
    //MOVE THIS TO THE VIEW MODEL
    private func deleteReminder(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let reminder = viewModel.reminders[index]
            Task {
                let result = await remindersRepo.deleteReminder(reminder.id)
                switch result {
                case .success(let res):
                    if res == true {
                        
                    }
                case .failure(let error):
                    print("Error while deleting")
                }
            }
            
        }
    }
    
    var body: some View {
        Group {
            let _ = Self._printChanges()
            let _ = print("Current state \(viewModel)")
            switch viewModel.state {
            case .loading:
                var _ = print("Rendering loader")
                ProgressView()
            case .error(let message):
                var _ = print("Rendering error")
                FancyToastView(type: .error, title: "Error", message: message, onCancelTapped: {})
            case .empty(let message):
                var _ = print("Rendering empty view")
                Text(message)
            case .loaded(let reminders):
                var _ = print("Rendering reminders \(reminders)")
                VStack {
                    List {
                        ForEach(reminders) { reminder in
                            ReminderCellView(reminder: reminder, isSelected: isReminderSelected(reminder)) { event in
                                switch event {
                                case .onInfo:
                                    showReminderDetail = true
                                case .onSelect(let reminder):
                                    selectedReminder = reminder
                                case .onCheckedChange(let reminder, let checked):
                                    reminderCheckedChanged(reminder: reminder, checked: checked)
                                }
                            }
                        }.onDelete(perform: deleteReminder)
                    }
                }
//                .sheet(isPresented: $showReminderDetail) {
//                    // ReminderDetailsView(reminder: Binding($selectedReminder)!)
//                }
            }
        }.onAppear {
            viewModel.listID = myList.id
            Task {
                await viewModel.load()
            }
        }
        
    }
}

//struct ReminderListView_Previews: PreviewProvider {
//    struct ReminderListContainerView: View {
//        @FetchRequest(sortDescriptors: [])
//        private var reminderResults: FetchedResults<Reminder>
//
//        var body: some View {
//            ReminderListView(viewModel: RemindersListViewModel(remindersRepo: ReminderRepositoryImpl(dataSource: ReminderDataSourceImpl(listDataSource: MyListDataSourceImpl())), listID: UUID()))
//        }
//    }
//    static var previews: some View {
//        ReminderListContainerView()
//            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
//    }
//}
