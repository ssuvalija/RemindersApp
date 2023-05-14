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
    }
    
    var myListRepository: Factory<MyListRepository> {
        Factory(self) { MyListRepositoryImpl(dataSource: self.myListDataSource()) }
    }
    
    var myListViewModel: Factory<MyListViewModel> {
        Factory(self) { MyListViewModel() }
    }
    
    var myListViewModelLoadedMock: Factory<MyListViewModel> {
        Factory(self) { MockMyListViewModels.mockLoadedState() }
    }
    
    var myListViewModelErrorMock: Factory<MyListViewModel> {
        Factory(self) { MockMyListViewModels.mockErrorState() }
    }
    
    var myListViewModelEmptyMock: Factory<MyListViewModel> {
        Factory(self) { MockMyListViewModels.mockEmptyState() }
    }
}
