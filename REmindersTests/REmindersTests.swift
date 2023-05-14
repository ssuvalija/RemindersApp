//
//  REmindersTests.swift
//  REmindersTests
//
//  Created by Selma Suvalija on 5/8/23.
//

import XCTest
import Factory
@testable import REminders

final class MyListTests: XCTestCase {
    


    func testMyListDataCount() async throws {
        Container.shared.myListRepository.register { MockMyListDataRepo() }

        let sut: MyListViewModel = MyListViewModel()
        
        switch sut.state {

        case .loading:
            print("state is loading as expected")
        default:
            XCTFail("View is not in loading state")
        }
        
        await sut.getLists()
        
        switch sut.state {
            
        case .loaded(let list):
            XCTAssertEqual(list.count, 2)
        default:
            XCTFail("List was not loaded")
        }
    }
    
    func testMyListErrorDisplay() async throws {
        Container.shared.myListRepository.register { MockMyListErrorDataRepo() }

        let sut: MyListViewModel = MyListViewModel()

        switch sut.state {
            
        case .loading:
            print("state is loading as expected")
        default:
            XCTFail("View is not in loading state")
        }
        
        await sut.getLists()
        
        switch sut.state {
            
        case .error(let message):
            XCTAssert(!message.isEmpty)
        default:
            XCTFail("Error was not received")
        }
    }

}
