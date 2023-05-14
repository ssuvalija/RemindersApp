//
//  AddListViewModelImpl.swift
//  REminders
//
//  Created by Selma Suvalija on 5/5/23.
//

import Foundation
import SwiftUI

class AddListViewModelImpl: ObservableObject {
    
    @Environment(\.dismiss) var dismiss
    @Published var error: String?
    @Published var name: String = "" {
        didSet {
            isFormValid = !name.isEmpty
        }
    }
    @Published var color: Color = .yellow
    @Published var isFormValid = false
    
    private var dataRepository: MyListRepository
    
    init(error: String? = nil, dataRepository: MyListRepository) {
        self.error = error
        self.dataRepository = dataRepository
    }
    
    init() {
        self.dataRepository = MyListRepositoryImpl(dataSource: MyListDataSourceImpl())
    }
    
    func addList() async -> Bool {
        let data = MyListData(id: UUID(), name: name, color: UIColor(color))
        let result = await dataRepository.createList(data)
        
        switch result {
        case .success(_):
            return true
        case .failure(let error):
            self.error = error.localizedDescription
            return false
        }
    }
}
