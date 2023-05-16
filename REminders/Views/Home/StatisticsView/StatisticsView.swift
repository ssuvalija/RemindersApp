//
//  StatisticsView.swift
//  REminders
//
//  Created by Selma Suvalija on 5/3/23.
//

import SwiftUI
import Factory

struct StatisticsView: View {
    @EnvironmentObject private var coordinator: Coordinator<RemindersRouter>
    
    @ObservedObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        VStack {
            HStack {
                ReminderStatsView(icon: "calendar", title: "Today", count: viewModel.todayCount)
                    .onTapGesture {
                        coordinator.show(.reminders(.todays))
                    }
                
                ReminderStatsView(icon: "tray.circle.fill", title: "All", count: viewModel.allCount, iconColor: .secondary)
                    .onTapGesture {
                        coordinator.show(.reminders(.all))
                    }
            }
            
            HStack {
                ReminderStatsView(icon: "clock.fill", title: "Scheduled", count: viewModel.scheduledCount, iconColor: .red)
                    .onTapGesture {
                        coordinator.show(.reminders(.scheduled))
                    }
                
                ReminderStatsView(icon: "checkmark.circle.fill", title: "Completed", count: viewModel.completedCount)
                    .onTapGesture {
                        coordinator.show(.reminders(.completed))
                    }
                
            }
        }.onAppear {
            Task {
                await viewModel.calculateStatistics()
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.shared.remindersRepo.register { MockRemindersRepo() }
        StatisticsView()
    }
}
