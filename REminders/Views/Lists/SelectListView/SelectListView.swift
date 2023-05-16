//
//  SelectListView.swift
//  REminders
//
//  Created by Selma Suvalija on 4/28/23.
//

import SwiftUI
import Factory

struct SelectListView: View {
    @ObservedObject private var viewModel: SelectListViewModel = SelectListViewModel()
    @Binding var selectedList: MyListData?
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView().onAppear {
                Task {
                    await viewModel.getLists()
                }
            }
        case .error(let error):
            FancyToastView(type: .error, title: "Error", message: error, onCancelTapped: {})
        case .loaded(let lists):
            List(lists) { myList in
                HStack {
                    HStack {
                        Image(systemName: "line.3.horizontal.circle.fill")
                            .foregroundColor(Color(myList.color))
                        Text(myList.name)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectedList = myList
                    }
                    
                    Spacer()
                    
                    if selectedList == myList {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }

    }
}

struct SelectListView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.shared.myListRepository.register { MockMyListDataRepo() }
        SelectListView(selectedList: .constant(MockMyListData.getList1()))
    }
}
