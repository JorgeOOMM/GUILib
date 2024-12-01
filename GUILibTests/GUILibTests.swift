//
//  GUILibTests.swift
//  GUILibTests
//
//  Created by Mac on 1/12/24.
//

import XCTest
@testable import GUILib

final class GUILibTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testCGSizeMath() {
        let greater = CGSize(width: 20, height: 30)
        let minimun = CGSize(width: 10, height: 20)
        let point = CGSize(width: 23.2, height: 3.1)
        let center = CGSize(width: 10, height: 10)
        XCTAssertEqual(point.integral, CGSize(width: 23, height: 3))
        XCTAssert(center.center.x == 5 &&
                  center.center.y == 5)
        XCTAssertEqual(greater.max, 30)
        XCTAssertEqual(greater.min, 20)
        XCTAssertEqual(minimun.max, 20)
        XCTAssertEqual(minimun.min, 10)
        XCTAssertEqual(minimun.max(greater), greater)
    }
    func testCGPointCGSizeExtension() {
        XCTAssertEqual((CGPoint(x: 10, y: 20) + CGPoint(x: 50, y: 70)),
                        CGPoint(x: 60, y: 90))
        XCTAssertEqual(CGPoint(x: 50, y: 70) - CGPoint(x: 10, y: 20),
                       CGPoint(x: 40, y: 50))
        XCTAssertEqual(CGPoint(x: 150, y: 100) * 3,
                         CGPoint(x: 450, y: 300))
        XCTAssertEqual(CGPoint(x: 500, y: 1000) / 5,
                         CGPoint(x: 100, y: 200))
        XCTAssertEqual(CGSize(width: 30, height: 40) + CGSize(width: 10, height: 90),
                        CGSize(width: 40, height: 130))
        XCTAssertEqual(CGSize(width: 100, height: 90) - CGSize(width: 10, height: 20),
                           CGSize(width: 90, height: 70))
        XCTAssertEqual(CGSize(width: 150, height: 100) * 3,
                             CGSize(width: 450, height: 300))
        XCTAssertEqual(CGSize(width: 500, height: 1000) / 5,
                       CGSize(width: 100, height: 200))
        XCTAssertEqual(CGSize(width: 30, height: 40) + CGPoint(x: 10, y: 90),
                        CGSize(width: 40, height: 130))
        XCTAssertEqual(CGSize(width: 100, height: 90) - CGPoint(x: 10, y: 20),
                           CGSize(width: 90, height: 70))
        XCTAssertEqual(CGSize(width: 30, height: 40) * CGPoint(x: 10, y: 90),
                        CGSize(width: 300.0, height: 3600.0))
        XCTAssertEqual(CGSize(width: 100, height: 90) / CGPoint(x: 10, y: 20),
                           CGSize(width: 10.0, height: 4.5))
     }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
