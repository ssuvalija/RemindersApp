//
//  Routes.swift
//  REminders
//
//  Created by Selma Suvalija on 5/18/23.
//

import Foundation

import SwiftUI

enum RemindersRouter: Routable {
    
    case home
    case reminders(ReminderListViewType)
    case addList
    case reminderDetails(ReminderData, onDismiss: () -> Void)
    case listDetails(MyListData)
    
    public var transition: NavigationTranisitionStyle {
        switch self {
        case .home:
            return .push
        case .addList:
            return .presentModally
        case .reminders:
            return .push
        case .reminderDetails:
            return .presentModally
        case .listDetails:
            return .push
        }
    }
    
    @ViewBuilder
    public func view() -> some View {
        switch self {
        case .home:
            HomeView()
        case .reminders(let type):
            ReminderListView(type: type)
        case .addList:
            AddNewListView()
        case .reminderDetails(let reminder, let onDismiss):
            ReminderDetailsView(reminder: reminder, onDismiss: onDismiss)
        case .listDetails(let list):
            MyListDetailView(myList: list)
        }
    }
}
