//
//  StatisticsView.swift
//  REminders
//
//  Created by Selma Suvalija on 5/3/23.
//

import SwiftUI

struct StatisticsView: View {
    
    let myLists: FetchedResults<MyList>
    
    init(myLists: FetchedResults<MyList>) {
        self.myLists = myLists
    }
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .today))
    private var todayResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .all))
    private var allResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .scheduled))
    private var scheduledResults: FetchedResults<Reminder>
    
    @FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .completed))
    private var completedResults: FetchedResults<Reminder>
    
    private var reminderStatsBuilder = ReminderStatsBuilder()
    @State private var reminderStatsValues = ReminderStatsValues()
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink {
                   // ReminderListView(reminders: todayResults)
                } label: {
                    ReminderStatsView(icon: "calendar", title: "Today", count: reminderStatsValues.todayCount)
                }
                
                NavigationLink {
                   // ReminderListView(reminders: allResults)
                } label: {
                    ReminderStatsView(icon: "tray.circle.fill", title: "All", count: reminderStatsValues.allCount, iconColor: .secondary)
                }
            }
            
            HStack {
                NavigationLink {
                   // ReminderListView(reminders: scheduledResults)
                } label: {
                    ReminderStatsView(icon: "clock.fill", title: "Scheduled", count: reminderStatsValues.scheduledCount, iconColor: .red)
                }
                
                NavigationLink {
                   // ReminderListView(reminders: completedResults)
                } label: {
                    ReminderStatsView(icon: "checkmark.circle.fill", title: "Completed", count: reminderStatsValues.completedCount)
                }
                
            }
        }.onAppear {
            reminderStatsValues = reminderStatsBuilder.build(myListResults: myLists)
        }
    }
}

//struct StatisticsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatisticsView()
//    }
//}
