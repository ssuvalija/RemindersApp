//
//  ReminderDetailsView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/28/23.
//

import SwiftUI

struct ReminderDetailsView: View {
    @EnvironmentObject private var coordinator: Coordinator<RemindersRouter>
    @ObservedObject private var viewModel: ReminderDetailsViewModel
    private var onDismiss: () -> Void
    
    init(reminder: ReminderData, onDismiss: @escaping () -> Void) {
        viewModel = ReminderDetailsViewModel(reminder: reminder)
        self.onDismiss = onDismiss
    }
    
    private var isFormValid: Bool {
        !viewModel.reminder.title.isEmpty
    }
    
    var body: some View {
        VStack {
            HeaderView(rightButtonTitle: "Done",
                       rightButtonAction: {
                Task {
                    await viewModel.updateReminder()
                }
                onDismiss()
                coordinator.dismiss()
                
            }, title: "Details",
                       leftButtonTitle: "Dismiss",
                       leftButtonAction: {
                onDismiss()
                coordinator.dismiss()
            },
                       disabledRightButton: {
                return !isFormValid
            })
            List {
                Section {
                    TextField("Title", text: $viewModel.reminder.title)
                    TextField("Notes", text: $viewModel.reminder.notes ?? "")
                }
                
                renderDateAndTimeSection()
                renderListSection()
            }.listStyle(.insetGrouped)
        }
    }
    
    private func renderDateAndTimeSection() -> AnyView {
        return AnyView(
            Section {
                Toggle(isOn: $viewModel.reminder.hasDate) {
                    Image(systemName: "calendar")
                        .foregroundColor(.red)
                }
                
                if  viewModel.reminder.hasDate {
                    DatePicker("Select Date", selection: $viewModel.reminder.reminderDate ?? Date(), displayedComponents: .date)
                }
                
                Toggle(isOn: $viewModel.reminder.hasTime) {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                }
                
                if viewModel.reminder.hasTime {
                    DatePicker("Select Time", selection: $viewModel.reminder.reminderTime ?? Date(), displayedComponents: .hourAndMinute)
                }
                
            }
                .onChange(of: viewModel.reminder.hasDate) { [weak viewModel] hasDate in
                    viewModel?.hasDateChanged(hasDate: hasDate)
                }
                .onChange(of: viewModel.reminder.hasTime) { [weak viewModel] hasTime in
                    viewModel?.hasTimeChanged(hasTime: hasTime)
                }
        )
    }
    
    private func renderListSection() -> AnyView {
        return AnyView(
            Section {
                NavigationLink(destination: {
                    SelectListView(selectedList: $viewModel.reminder.list)
                }, label: {
                    HStack {
                        Text("List")
                        Spacer()
                        Text(viewModel.reminder.list?.name ?? "")
                    }
                })
            }
        )
    }
    
}

struct ReminderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderDetailsView(reminder: MockRemindersData.getReminder1(), onDismiss: {})
    }
}
