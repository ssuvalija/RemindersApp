//
//  MyListDetailView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/27/23.
//

import SwiftUI
import Factory

struct MyListDetailView: View {
    let myList: MyListData
    @State private var openAddReminder: Bool = false
    
    init(myList: MyListData) {
        self.myList = myList
    }
    
    var body: some View {
        VStack {
            //Display list of reminders
            ReminderListView(myList: myList, type: .listReminders)
            
            HStack {
                Image(systemName: "plus.circle.fill")
                Button("New Reminder") {
                    openAddReminder = true
                }
            }
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(myList.name)
        .alert("New Reminder", isPresented: $openAddReminder) {
            AddReminderView(myList: myList)
        }
    }
}

struct MyListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyListDetailView(myList: MyListData(id: UUID(), name: "my list", color: .yellow))
    }
}
