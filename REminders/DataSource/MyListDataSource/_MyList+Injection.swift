//
//  _MyList+Injection.swift
//  REminders
//
//  Created by Selma Suvalija on 5/10/23.
//

import Foundation
import Factory

extension Container {
     var myListDataSource: Factory<MyListDataSource> {
         Factory(self) { MyListDataSourceImpl() }
             .scope(.singleton)
    }
    
    var myListRepository: Factory<MyListRepository> {
        Factory(self) { MyListRepositoryImpl(dataSource: self.myListDataSource()) }
            .scope(.singleton)
    }
    
    var myListViewModel: Factory<MyListViewModel> {
        Factory(self) { MyListViewModel() }
    }
    
    var myListViewModelLoadedMock: Factory<MyListViewModel> {
        Factory(self) { MockMyListViewModels.mockLoadedState() }
            .scope(.singleton)
    }
    
    var myListViewModelErrorMock: Factory<MyListViewModel> {
        Factory(self) { MockMyListViewModels.mockErrorState() }
            .scope(.singleton)
    }
    
    var myListViewModelEmptyMock: Factory<MyListViewModel> {
        Factory(self) { MockMyListViewModels.mockEmptyState() }
            .scope(.singleton)
    }
}
