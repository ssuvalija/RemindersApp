//
//  MyListRepository.swift
//  REminders
//
//  Created by Selma Suvalija on 5/5/23.
//

import Foundation
import Combine

protocol MyListRepository {
    var notificationsPublisher: PassthroughSubject<Bool, Never> { get }
    func getLists() async -> Result<[MyListData], DataSourceError>
    func getList(id: UUID) async -> Result<MyListData?, DataSourceError>
    func deleteList(_ id: UUID) async -> Result<Bool, DataSourceError>
    func createList(_ list: MyListData) async -> Result<Bool, DataSourceError>
    func updateList(_ list: MyListData) async -> Result<Bool, DataSourceError>
}
