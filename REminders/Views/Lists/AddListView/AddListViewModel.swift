//
//  AddListViewModel.swift
//  REminders
//
//  Created by Selma Suvalija on 5/5/23.
//

import Foundation

protocol AddListViewModel {
    var error: String? { get }
    func addList(list: MyListData) async -> Bool
}
