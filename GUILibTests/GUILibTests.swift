//
//  GUILibTests.swift
//  GUILibTests
//
//  Created by Mac on 1/12/24.
//

import XCTest
@testable import GUILib
// Helpers
fileprivate func randomNumber(probabilities: [Double]) -> Int {
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

fileprivate func randomSize(bounded bounds: CGRect,
                            numberOfItems: Int) -> [CGSize] {
    let randomSizes  = (0..<numberOfItems).map {
        _ in CGSize(width: .random(min: 0, max: bounds.size.width),
                    height: .random(min: 0, max: bounds.size.height))
    }
    return randomSizes
}
fileprivate func randomFloat(_ numberOfItems: Int, min: Float = 0, max: Float = 100000) -> [Float] {
    let randomData = (0..<numberOfItems).map { _ in Float.random(min: min, max: max) }
    return randomData
}

fileprivate func loadPointsFromJSON(from bundle:Bundle, fileName: String) -> [CGPoint] {
    var points: [CGPoint] = []
    let testDataPath = bundle.path(forResource: fileName, ofType: "json")
    guard let testData = try? Data(contentsOf: URL(fileURLWithPath: testDataPath!), options: []) else {
        return []
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
    
    return points
}

final class GUILibTests: XCTestCase {
    fileprivate var points: [CGPoint] = []
    
    override func setUpWithError() throws {
        self.points = loadPointsFromJSON(from: Bundle(for: type(of: self)), fileName: "test-data")
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
    func testScaledPointsGenerator() {
        let numberOfItems = 300
        let sizes = randomSize(bounded: UIScreen.main.bounds, numberOfItems: numberOfItems)
        let scaler  = DiscreteScaledPointsGenerator()
        let randomData = randomFloat(numberOfItems)
        for size in sizes {
            let scaler2 = ScaledPointsGenerator(randomData, size: size, insets: .zero)
            let points  = scaler.makePoints(data: randomData, size: size, updateLimits: true)
            let result = points.map { CGRect(origin: .zero, size: size).contains($0) }
            let points2 = scaler2.makePoints()
            let result2 = points2.map { CGRect(origin: .zero, size: size).contains($0) }
            XCTAssert(points == points2, "ScaledPointsGenerator points")
            XCTAssert(result == result2, "ScaledPointsGenerator bounds")
        }
    }
    // Test the PolylineSimplify core class
    func testSimplify() {
        let result0 = PolylineSimplify.simplify(self.points, tolerance: Float(0))
        XCTAssertEqual(result0.count, 36861, "PolylineSimplify.simplify tolerance (0)")
        let result1 = PolylineSimplify.simplify(self.points, tolerance: Float(0.1))
        XCTAssertEqual(result1.count, 1014, "PolylineSimplify.simplify tolerance (0.1)")
        let result2 =  PolylineSimplify.simplify(self.points, tolerance: Float(0.5))
        XCTAssertEqual(result2.count, 243, "PolylineSimplify.simplify tolerance (0.5)")
        let result3 =  PolylineSimplify.simplify(self.points, tolerance: Float(1.0))
        XCTAssertEqual(result3.count, 129, "PolylineSimplify.simplify tolerance (1.0)")
        let result4 =  PolylineSimplify.simplify(self.points, tolerance: Float(2.0))
        XCTAssertEqual(result4.count, 64, "PolylineSimplify.simplify tolerance (2.0)")
        let result5 =  PolylineSimplify.simplify(self.points, tolerance: Float(4.0))
        XCTAssertEqual(result5.count, 37, "PolylineSimplify.simplify tolerance (4.0)")
        let result6 =  PolylineSimplify.simplify(self.points, tolerance: Float(5.0))
        XCTAssertEqual(result6.count, 30, "PolylineSimplify.simplify tolerance (5.0)")
    }
    // Test the Interpolation core class
    func testInterpolation() {
        let var1 = 0.5, var2 = 0.5, var3 = 0.5, var4 = 0.5, var5 = 0.5, var6 = 0.5
        // Alpha 0.5
        var alpha = 0.5
        var lerp = Interpolation.lerp(var1, lerpy1: var2, alpha: alpha)
        var coserp = Interpolation.coserp(var1, coserpy1: var2, alpha: alpha)
        var cubicerp = Interpolation.cubicerp(var1, cubicerpy1: var2, cubicerpy2: var3, cubicerpy3: var4, alpha: alpha)
        var eerp = Interpolation.eerp(var1, eerpy1: var2, alpha: alpha)
        var bilerp = Interpolation.bilerp(var1,
                                          bilerpy1: var2,
                                          bilerpt1: var3,
                                          bilerpy2: var4,
                                          bilerpy3: var5,
                                          bilerpt2: var6)
        XCTAssertEqual(lerp, 0.5, "lerp Interpolation (alpha 0.5)")
        XCTAssertEqual(coserp, 0.5, "coserp Interpolation (alpha 0.5)")
        XCTAssertEqual(cubicerp, 0.5, "cubicerp Interpolation (alpha 0.5)")
        XCTAssertEqual(bilerp, 0.5, "bilerp Interpolation (alpha 0.5)")
        XCTAssertEqual(eerp, 1.0, "eerp Interpolation (alpha 0.5)")
        // Alpha 1.0
        alpha = 1.0
        lerp = Interpolation.lerp(var1, lerpy1: var2, alpha: alpha)
        coserp = Interpolation.coserp(var1, coserpy1: var2, alpha: alpha)
        cubicerp = Interpolation.cubicerp(var1, cubicerpy1: var2, cubicerpy2: var3, cubicerpy3: var4, alpha: alpha)
        eerp = Interpolation.eerp(var1, eerpy1: var2, alpha: alpha)
        bilerp = Interpolation.bilerp(var1,
                                      bilerpy1: var2,
                                      bilerpt1: var3,
                                      bilerpy2: var4,
                                      bilerpy3: var5,
                                      bilerpt2: var6)
        XCTAssertEqual(lerp, 0.5, "lerp Interpolation (alpha 1.0)")
        XCTAssertEqual(coserp, 0.5, "coserp Interpolation  (alpha 1.0)")
        XCTAssertEqual(cubicerp, 0.5, "cubicerp Interpolation (alpha 1.0)")
        XCTAssertEqual(bilerp, 0.5, "bilerp Interpolation  (alpha 1.0)")
        XCTAssertEqual(eerp, 2.0, "eerp Interpolation (alpha 1.0)")
        // Alpha 0
        alpha = 0
        lerp = Interpolation.lerp(var1, lerpy1: var2, alpha: alpha)
        coserp = Interpolation.coserp(var1, coserpy1: var2, alpha: alpha)
        cubicerp = Interpolation.cubicerp(var1, cubicerpy1: var2, cubicerpy2: var3, cubicerpy3: var4, alpha: alpha)
        eerp = Interpolation.eerp(var1, eerpy1: var2, alpha: alpha)
        bilerp = Interpolation.bilerp(var1,
                                      bilerpy1: var2,
                                      bilerpt1: var3,
                                      bilerpy2: var4,
                                      bilerpy3: var5,
                                      bilerpt2: var6)
        XCTAssertEqual(lerp, 0.5, "lerp Interpolation (alpha 0)")
        XCTAssertEqual(coserp, 0.5, "coserp Interpolation (alpha 0)")
        XCTAssertEqual(cubicerp, 0.5, "cubicerp Interpolation (alpha 0)")
        XCTAssertEqual(bilerp, 0.5, "bilerp Interpolation (alpha 0)")
        XCTAssertEqual(eerp, 0.5, "eerp Interpolation (alpha 0)")
    }
}
