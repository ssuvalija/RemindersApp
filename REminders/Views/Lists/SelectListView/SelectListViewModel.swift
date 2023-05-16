//
//  SelectListViewModel.swift
//  REminders
//
//  Created by Selma Suvalija on 5/15/23.
//

import Foundation
import Factory
import Combine

enum SelectListViewModelState: Equatable {
    case error(String)
    case loading
    case loaded([MyListData])
}

class SelectListViewModel: ObservableObject {
    @Injected(\.myListRepository) private var listRepo: MyListRepository
    @Published var state: SelectListViewModelState = .loading
    
    @MainActor
    func getLists() async {
        if state != .loading {
            state = .loading
        }
        
        let result = await listRepo.getLists()
        
        switch result {
        case .success(let data):
            state = .loaded(data)
        case .failure(_):
            state = .error("Error occured while loading lists")
        }
    }
}
