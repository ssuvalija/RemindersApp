//
//  AddReminderView.swift
//  REminders
//
//  Created by Selma Suvalija on 5/9/23.
//

import SwiftUI
import Factory

struct AddReminderView: View {
    @ObservedObject var viewModel: AddReminderViewModel  = Container.shared.addReminderViewModel.resolve()
    @State private var title: String = ""
    let myList: MyListData
    private var isFormValid: Bool {
        !title.isEmpty
    }
    
    public init(myList: MyListData) {
        self.myList = myList
    }
    
    var body: some View {
        //ALERT IS AUTOMATICALLY CLOSED ON DONE AND THIS CODE CANT BE EXECUTED
//        switch viewModel.state {
//        case .error(let message):
//            FancyToastView(type: .error, title: "Error", message: message, onCancelTapped: {})
//        case .created:
//            FancyToastView(type: .success, title: "Success", message: "Reminder was successfuully created", onCancelTapped: {})
//        case .loading:
//            ProgressView()
//        }
        TextField("", text: $title)
        Button("Cancel", role: .cancel) {}
        Button("Done") {
            if isFormValid {
                Task {
                    await viewModel.createReminder(title: title, list: myList)
                }
            }
        }
    }
}

struct AddReminderView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.shared.remindersRepo.register{ MockRemindersRepo() }
        AddReminderView(myList: MyListData(id: UUID(), name: "list", color: .green))
    }
}
