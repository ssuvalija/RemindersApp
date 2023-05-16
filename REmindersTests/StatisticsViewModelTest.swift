//
//  StatisticsViewModelTest.swift
//  REmindersTests
//
//  Created by Selma Suvalija on 5/22/23.
//

import XCTest
import Factory
@testable import REminders

final class StatisticsViewModelTest: XCTestCase {

    override class func setUp() {
        Container.shared.remindersRepo.register { MockRemindersRepo() }.scope(.singleton)
    }
    
    override class func tearDown() {
        //Container.shared.remindersRepo.
    }

    func testTodayReminders() async throws {
        let sut = StatisticsViewModel()
        
        await sut.calculateStatistics()
        
        XCTAssertEqual(sut.todayCount, 1)
        XCTAssertEqual(sut.allCount, 3)
        XCTAssertEqual(sut.scheduledCount, 2)
        XCTAssertEqual(sut.completedCount, 1)
            
    }

}
