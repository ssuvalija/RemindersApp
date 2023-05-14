//
//  MyListError.swift
//  REminders
//
//  Created by Selma Suvalija on 5/5/23.
//

import Foundation

enum DataSourceError: Error{
 case DataSourceError, CreateError, DeleteError, UpdateError, FetchError
}
