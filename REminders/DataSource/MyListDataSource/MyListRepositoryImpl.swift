//
//  MyListRepositoryImpl.swift
//  REminders
//
//  Created by Selma Suvalija on 5/5/23.
//

import Foundation
import Combine

struct MyListRepositoryImpl: MyListRepository {
    
    let dataSource: MyListDataSource
    
    var notificationsPublisher: PassthroughSubject<Bool, Never>? {
        return dataSource.notificationsPublisher
    }
    
    func getLists() async -> Result<[MyListData], DataSourceError> {
        do {
            let lists = try await dataSource.getAll()
            return .success(lists.map { list in
                MyListData(myList: list)
            })
        } catch {
            return .failure(.FetchError)
        }
    }
    
    func getList(id: UUID) async -> Result<MyListData?, DataSourceError> {
        do {
            if let list = try await dataSource.getById(id) {
                return .success(MyListData(myList: list))
            } else {
                return .success(nil)
            }
        } catch {
            return .failure(.FetchError)
        }
    }
    
    func deleteList(_ id: UUID) async -> Result<Bool, DataSourceError> {
        do {
            try await dataSource.delete(id)
            return .success(true)
        } catch {
            return .failure(.DeleteError)
        }
    }
    
    func createList(_ list: MyListData) async -> Result<Bool, DataSourceError> {
        do {
            try await dataSource.create(list: list)
            return .success(true)
        } catch {
            return .failure(.CreateError)
        }
    }
    
    func updateList(_ list: MyListData) async -> Result<Bool, DataSourceError> {
        do {
            try await dataSource.update(id: list.id, list: list)
            return .success(true)
        } catch {
            return .failure(.UpdateError)
        }
    }
    
}
