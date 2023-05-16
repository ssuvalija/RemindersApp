//
//  ReminderDataSource.swift
//  REminders
//
//  Created by Selma Suvalija on 5/4/23.
//

import Foundation
import Combine

protocol MyListDataSource: AnyObject {
    var notificationsPublisher: PassthroughSubject<Bool, Never>? { get }
    func getAll() async throws -> [MyListEntity]
    func getById(_ id: UUID) async throws -> MyListEntity?
    func delete(_ id: UUID) async throws -> ()
    func create(list: MyListData) async throws -> ()
    func update(id: UUID, list: MyListData) async throws -> ()
}
