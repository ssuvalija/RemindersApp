//
//  MyListView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/27/23.
//

import SwiftUI
import Factory

struct MyListView: View {
    @EnvironmentObject private var coordinator: Coordinator<RemindersRouter>
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: MyListViewModel = MyListViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .error(let error):
                FancyToastView(type: .error, title: "Error", message: error, onCancelTapped: {})
            case .empty(let message):
                Text(message)
            case .loaded(let myLists):
                ForEach(myLists) { myList in
                    VStack {
                        MyListCellView(myList: myList)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .padding([.leading], 10)
                            .font(.title3)
                            .foregroundColor(colorScheme == .dark ? Color.offWhite : Color.darkGray)
                            .onTapGesture {
                                coordinator.show(.listDetails(myList))
                            }
                        Divider()
                    }
                    .listRowBackground(colorScheme == .dark ? Color.darkGray : Color.offWhite)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .onAppear {
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
