//
//  ReminderStatsView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/30/23.
//

import SwiftUI

struct ReminderStatsView: View {
    let icon: String
    let title: String
    var count: Int?
    var iconColor: Color = .blue
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.title)
                    Text(title)
                        .opacity(0.8)
                }
                Spacer()

                if let count {
                    Text("\(count)")
                        .font(.largeTitle)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(colorScheme == .dark ? Color.darkGray : .offWhite)
            .foregroundColor(colorScheme == .dark ? .offWhite : .darkGray)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        }
    }
}

struct ReminderStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderStatsView(icon: "calendar", title: "Today", count: 9)
    }
}
