//
//  ContentView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/25/23.
//

import SwiftUI

struct HomeView: View {
    @FetchRequest(sortDescriptors: [])
    private var myListResults: FetchedResults<MyList>
    
    @FetchRequest(sortDescriptors: [])
    private var searchResults: FetchedResults<Reminder>
    
    @State private var searchTerm: String = ""
    @State private var isPresented: Bool = false
    @State private var searching: Bool = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    StatisticsView(myLists: myListResults)
                    Text("My Lists")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    MyListView(viewModel: MyListViewModel())
                    
                    Button {
                        isPresented = true
                    } label: {
                        Text("Add LIst")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                    }.padding()
                }
            }
            .onChange(of: searchTerm, perform: { newValue in
                searching = !searchTerm.isEmpty ? true : false
                searchResults.nsPredicate = ReminderService.getRemindersBySearchTerm(searchTerm).predicate
            })
            .overlay(alignment: .center, content: {
//                ReminderListView(reminders: searchResults)
//                    .opacity(searching ? 1.0 : 0.0)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    AddNewListView(viewModel: AddListViewModelImpl()) 
                }
            }
            .navigationTitle("Reminders")
            .padding()
        }
        .searchable(text: $searchTerm)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
    }
}
