//
//  MyListView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/27/23.
//

import SwiftUI
import Factory

struct MyListView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: MyListViewModel = Container.shared.myListViewModel.resolve()
    
    var body: some View {
        NavigationStack {
            let _ = Self._printChanges()
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .error(let error):
                FancyToastView(type: .error, title: "Error", message: error, onCancelTapped: {})
            case .empty(let message):
                Text(message)
            case .loaded(let myLists):
                ForEach(myLists) { myList in
                    NavigationLink(value: myList) {
                        VStack {
                            MyListCellView(myList: myList)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading], 10)
                                .font(.title3)
                                .foregroundColor(colorScheme == .dark ? Color.offWhite : Color.darkGray)
                            Divider()
                        }
                    }.listRowBackground(colorScheme == .dark ? Color.darkGray : Color.offWhite)
                }
                .scrollContentBackground(.hidden)
                .navigationDestination(for: MyListData.self) { myList in
                    MyListDetailView(myList: myList)
                        .navigationTitle(myList.name)
                }
            }
        }.onAppear {
            Task {
                await viewModel.getLists()
            }
        }
    }
}

struct MyListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let _ = Container.shared.myListViewModel.register { MockMyListViewModels.mockLoadedState() }
            MyListView()
            
            let _ = Container.shared.myListViewModel.register { MockMyListViewModels.mockErrorState() }
            MyListView()
            
            let _ = Container.shared.myListViewModel.register { MockMyListViewModels.mockEmptyState() }
            MyListView()
        }
    }
}
