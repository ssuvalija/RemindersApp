//
//  ReminderDetailsView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/28/23.
//

import SwiftUI

struct ReminderDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var reminder: Reminder
    @State var editConfig: ReminderEditConfig = ReminderEditConfig()
    
    private var isFormValid: Bool {
        !editConfig.title.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("Title", text: $editConfig.title)
                        TextField("Notes", text: $editConfig.notes ?? "")
                    }
                    
                    Section {
                        Toggle(isOn: $editConfig.hasDate) {
                            Image(systemName: "calendar")
                                .foregroundColor(.red)
                        }
                        
                        if editConfig.hasDate {
                            DatePicker("Select Date", selection: $editConfig.reminderDate ?? Date(), displayedComponents: .date)
                        }
                        
                        
                        Toggle(isOn: $editConfig.hasTime) {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                        }
                        
                        if editConfig.hasTime {
                            DatePicker("Select Time", selection: $editConfig.reminderTime ?? Date(), displayedComponents: .hourAndMinute)
                        }
                        
                        Section {
                            NavigationLink(destination: {
                                SelectListView(selectedList: $reminder.list)
                            }, label: {
                                HStack {
                                    Text("List")
                                    Spacer()
                                    Text(reminder.list?.name ?? "")
                                }
                            })
                        }
                    }.onChange(of: editConfig.hasDate) { hasDate in
                        if hasDate == true {
                            editConfig.reminderDate = Date()
                        }
                    }
                    .onChange(of: editConfig.hasTime) { hasTime in
                        if hasTime == true {
                            editConfig.reminderTime = Date()
                        }
                    }
                }.listStyle(.insetGrouped)
            }
            .onAppear {
                editConfig = ReminderEditConfig(reminder: reminder)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Details")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        do {
                            let updated = try ReminderService.updateReminder(reminder: reminder, editConfig: editConfig)
                            
                            if updated {
                                if reminder.reminderDate != nil || reminder.reminderTime != nil {
                                    let userData = UserData(title: reminder.title, body: reminder.notes, date: reminder.reminderDate, time: reminder.reminderTime)
                                    
                                    NotificationManager.scheduleNotification(userData: userData)
                                }
                            }
                        } catch {
                            assertionFailure("Failed to update freminder")
                            print(error)
                        }
                        dismiss()

                    }.disabled(!isFormValid)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
                
            }
        }
    }
}

struct ReminderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderDetailsView(reminder: .constant(PreviewData.reminder))
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}
