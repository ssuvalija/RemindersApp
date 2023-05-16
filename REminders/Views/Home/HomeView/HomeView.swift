//
//  ContentView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/25/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: Coordinator<RemindersRouter>

    @State private var searchTerm: String = ""
    @State private var searching: Bool = false
    
    var body: some View {
        let _ = print("IS SEARCH VISIBLE \(searching)")
        NavigationStack {
            VStack {
                ScrollView {
                    StatisticsView()
                    Text("My Lists")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    MyListView()
                    
                    Button {
                        coordinator.show(.addList)
                    } label: {
                        Text("Add LIst")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                    }.padding()
                }
            }
            .onChange(of: searchTerm, perform: { newValue in
                searching = !searchTerm.isEmpty ? true : false
            })
            .overlay(alignment: .center, content: {
                ReminderListView(type: .search, searchTerm: $searchTerm)
                    .opacity(searching ? 1.0 : 0.0)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Reminders")
            .padding()
        }
        .searchable(text: $searchTerm)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
