//
//  MyListViewModel.swift
//  REminders
//
//  Created by Selma Suvalija on 5/5/23.
//

import Foundation
import Combine
import Factory

class MyListViewModel: ObservableObject {
    enum MyListState {
        case loading
        case loaded(_ list: [MyListData])
        case empty(_ message: String)
        case error(_ message: String)
    }
    
    @Published var state: MyListState = .loading
    @Injected(\.myListRepository) private var dataRepository: MyListRepository
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        subscribeForDataUpdatesNotifications()
    }
    
    @MainActor
    func getLists() async {
        let result = await dataRepository.getLists()
        switch result {
        case .success(let data):
            if data.isEmpty {
                state = .empty("No lists found")
            } else {
                state = .loaded(data)
            }
        case .failure(_):
            state = .error("Error happened while loading lists")
        }
    }
    
    private func subscribeForDataUpdatesNotifications() {
        dataRepository.notificationsPublisher?.sink { [weak self] shouldUpdate in
            if shouldUpdate {
                Task { [weak self] in
                    await self?.getLists()
                }
            }
        }.store(in: &cancellables)
    }
}
