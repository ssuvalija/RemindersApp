//
//  MockMyListDataRepo.swift
//  REminders
//
//  Created by Selma Suvalija on 5/8/23.
//

import Foundation
import Combine
import Factory

enum MockMyListData {
    static func getList1() -> MyListData {
        return MyListData(id: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000") ?? UUID(), name: "my list", color: .cyan)
    }
    
    static func getList2() -> MyListData {
        MyListData(id: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174001") ?? UUID(), name: "my list 2", color: .red)
    }
}

struct MockMyListDataRepo: MyListRepository {
    var notificationsPublisher = PassthroughSubject<Bool, Never>()
    
    func getLists() async -> Result<[MyListData], DataSourceError> {
        return .success(
            [MockMyListData.getList1(), MockMyListData.getList2()])
    }
    
    func getList(id: UUID) async -> Result<MyListData?, DataSourceError> {
        return .success(MockMyListData.getList1())
    }
    
    func deleteList(_ id: UUID) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
    
    func createList(_ list: MyListData) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
    
    func updateList(_ list: MyListData) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
}

struct MockMyListEmptyDataRepo: MyListRepository {
    var notificationsPublisher = PassthroughSubject<Bool, Never>()
    
    func getLists() async -> Result<[MyListData], DataSourceError> {
        return .success([])
    }
    
    func getList(id: UUID) async -> Result<MyListData?, DataSourceError> {
        return .success(nil)
    }
    
    func deleteList(_ id: UUID) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
    
    func createList(_ list: MyListData) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
    
    func updateList(_ list: MyListData) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
}

struct MockMyListErrorDataRepo: MyListRepository {
    var notificationsPublisher = PassthroughSubject<Bool, Never>()
    
    func getLists() async -> Result<[MyListData], DataSourceError> {
        return .failure(.FetchError)
    }
    
    func getList(id: UUID) async -> Result<MyListData?, DataSourceError> {
        return .success(nil)
    }
    
    func deleteList(_ id: UUID) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
    
    func createList(_ list: MyListData) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
    
    func updateList(_ list: MyListData) async -> Result<Bool, DataSourceError> {
        return .success(true)
    }
}

struct MockMyListViewModels {
    static func mockLoadingState() -> MyListViewModel {
        Container.shared.myListRepository.register { MockMyListDataRepo() }
        let vm = MyListViewModel()
        vm.state = .loading
        return vm
    }
    
    static func mockErrorState() -> MyListViewModel {
        Container.shared.myListRepository.register { MockMyListErrorDataRepo() }
        let vm = MyListViewModel()
        vm.state = .error("Can't load lists")
        return vm
    }
    
    static func mockEmptyState() -> MyListViewModel {
        Container.shared.myListRepository.register { MockMyListEmptyDataRepo() }
        let vm = MyListViewModel()
        vm.state = .empty("No lists found")
        return vm
    }
    
    static func mockLoadedState() -> MyListViewModel {
        Container.shared.myListRepository.register { MockMyListDataRepo() }
        let vm = MyListViewModel()
        vm.state = .loaded([MockMyListData.getList1(),
                            MockMyListData.getList2()])
        return vm
    }
}
