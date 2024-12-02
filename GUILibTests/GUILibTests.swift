//
//  GUILibTests.swift
//  GUILibTests
//
//  Created by Mac on 1/12/24.
//

import XCTest
@testable import GUILib
func randomNumber(probabilities: [Double]) -> Int {
    // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
    let sum = probabilities.reduce(0, +)
    // Random number in the range 0.0 <= rnd < sum :
    let rnd = Double.random(in: 0.0 ..< sum)
    // Find the first interval of accumulated probabilities into which `rnd` falls:
    var accum = 0.0
    for (index, probabilitie) in probabilities.enumerated() {
        accum += probabilitie
        if rnd < accum {
            return index
        }
    }
    // This point might be reached due to floating point inaccuracies:
    return (probabilities.count - 1)
}
// MARK: - Random numbers
fileprivate extension BinaryInteger {
    static func random(min: Self, max: Self) -> Self {
        assert(min < max, "min must be smaller than max")
        let delta = max - min
        return min + Self(arc4random_uniform(UInt32(delta)))
    }
}
fileprivate extension FloatingPoint {
    static func random(min: Self, max: Self, resolution: Int = 1000) -> Self {
        let randomFraction = Self(Int.random(min: 0, max: resolution)) / Self(resolution)
        return min + randomFraction * max
    }
}

final class GUILibTests: XCTestCase {
    fileprivate var points: [CGPoint] = []
    override func setUpWithError() throws {
        let testDataPath = Bundle(for: type(of: self)).path(forResource: "test-data", ofType: "json")
        guard let testData = try? Data(contentsOf: URL(fileURLWithPath: testDataPath!), options: []) else {
            return
        }
        let testDataObj: AnyObject? = try? JSONSerialization.jsonObject(with: testData, 
                                                                        options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        if let testDataObj = testDataObj as? NSArray {
            for idx in 0 ..< testDataObj.count {
                if let itemDict = testDataObj[idx] as? NSDictionary {
                    if let itemDictX = itemDict["x"] as? NSNumber, let itemDictY = itemDict["y"] as? NSNumber {
                        points.append( CGPoint( x: CGFloat(itemDictX.floatValue), y: CGFloat(itemDictY.floatValue)) )
                    }
                }
            }
        }
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

    
    func randomSize(bounded bounds: CGRect,
                    numberOfItems: Int) -> [CGSize] {
        let randomSizes  = (0..<numberOfItems).map {
            _ in CGSize(width: .random(min: 0, max: bounds.size.width), 
                        height: .random(min: 0, max: bounds.size.height))
        }
        return randomSizes
    }
    func randomFloat(_ numberOfItems: Int, min: Float = 0, max: Float = 100000) -> [Float] {
        let randomData = (0..<numberOfItems).map { _ in Float.random(min: min, max: max) }
        return randomData
    }
    func testScaledPointsGenerator() {
        let numberOfItems = 300
        let sizes = randomSize(bounded: UIScreen.main.bounds, numberOfItems: numberOfItems)
        for size in sizes {
            let randomData = randomFloat(numberOfItems)
            let scaler2 = ScaledPointsGenerator(randomData, size: size, insets: .zero)
            let scaler  = DiscreteScaledPointsGenerator()
            let points  = scaler.makePoints(data: randomData, size: size)
            let result = points.map { CGRect(origin: .zero, size: size).contains($0) }
            let points2 = scaler2.makePoints()
            let result2 = points2.map { CGRect(origin: .zero, size: size).contains($0) }
            XCTAssert(points == points2)
            XCTAssert(result == result2)
        }
    }
    
    func testSimplify() {
        let result0 = PolylineSimplify.simplify(self.points, tolerance: Float(0))
        XCTAssert(result0.count == 36861)
        let result1 = PolylineSimplify.simplify(self.points, tolerance: Float(0.1))
        XCTAssert(result1.count == 1014)
        let result2 =  PolylineSimplify.simplify(self.points, tolerance: Float(0.5))
        XCTAssert(result2.count == 243)
        let result3 =  PolylineSimplify.simplify(self.points, tolerance: Float(1.0))
        XCTAssert(result3.count == 129)
        let result4 =  PolylineSimplify.simplify(self.points, tolerance: Float(2.0))
        XCTAssert(result4.count == 64)
        let result5 =  PolylineSimplify.simplify(self.points, tolerance: Float(4.0))
        XCTAssert(result5.count == 37)
        let result6 =  PolylineSimplify.simplify(self.points, tolerance: Float(5.0))
        XCTAssert(result6.count == 30)
    }
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
