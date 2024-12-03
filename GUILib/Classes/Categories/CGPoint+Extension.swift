//
//    Copyright 2015 - Jorge Ouahbi
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

//
//  CGPoint+Extension.swift
//
//  Created by Jorge Ouahbi
//  Copyright © 2020 Jorge Ouahbi. All rights reserved.
//

// v1.0

import UIKit
/**
 * ...
 * a == b
 */

func ==(lhs: CGPoint, rhs: CGPoint) -> Bool {
    return lhs.distanceFrom(rhs) < 0.000001 // lhs.equalTo(rhs)
}

//public func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
//    return lhs.equalTo(rhs)
//}

/**
 * ...
 * a + b
 */
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

/**
 * ...
 * a += b
 */
public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

/**
 * ...
 * a -= b
 */
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

/**
 * ...
 * a -= b
 */
public func -= (left: inout CGPoint, right: CGPoint) {
    left = left - right
}

/**
 * ...
 * a * b
 */
public func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

/**
 * ...
 * a *= b
 */
func *= (left: inout CGPoint, right: CGPoint) {
    left = left * right
}

/**
 * ...
 * a / b
 */
public func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

/**
 * ...
 * a /= b
 */
public func /= (left: inout CGPoint, right: CGPoint) {
    left = left / right
}

/**
 * ...
 * a * 10.4
 */
public func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

/**
 * ...
 * a *= 10.4
 */
public func *= (left: inout CGPoint, right: CGFloat) {
    left = left * right
}

/**
 * ...
 * a / 10.4
 */
func / (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}

/**
 * ...
 * a /= 10.4
 */
public func /= (left: inout CGPoint, right: CGFloat) {
    left = left / right
}
/**
 * ...
 * a + c
 */
public func + (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x + right.width, y: left.y + right.height)
}

/**
 * ...
 * a += c
 */
public func += (left: inout CGPoint, right: CGSize) {
    left = left + right
}

/**
 * ...
 * a - c
 */
public func - (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x - right.width, y: left.y - right.height)
}

/**
 * ...
 * a -= c
 */
public func -= (left: inout CGPoint, right: CGSize) {
    left = left - right
}

/**
 * ...
 * a * c
 */
public func * (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x * right.width, y: left.y * right.height)
}

/**
 * ...
 * a *= c
 */
public func *= (left: inout CGPoint, right: CGSize) {
    left = left * right
}

/**
 * ...
 * a / c
 */
public func / (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x / right.width, y: left.y / right.height)
}

/**
 * ...
 * a /= c
 */
public func /= (left: inout CGPoint, right: CGSize) {
    left = left / right
}

/**
 * ...
 * -a
 */
public prefix func - (left: CGPoint) -> CGPoint {
    return CGPoint(x: -left.x, y: -left.y)
}

/**
 * Get minimum x and y values of multiple points
 */
public func min(mina: CGPoint, minb: CGPoint, rest: CGPoint...) -> CGPoint {
    var minPoint = CGPoint(x: min(mina.x, minb.x), y: min(mina.y, minb.y))
    for point in rest {
        minPoint.x = min(minPoint.x, point.x)
        minPoint.y = min(minPoint.y, point.y)
    }
    return minPoint
}

/**
 * Get maximum x and y values of multiple points
 */
public func max(maxa: CGPoint, maxb: CGPoint, rest: CGPoint...) -> CGPoint {
    var maxPoint = CGPoint(x: max(maxa.x, maxb.x), y: max(maxa.y, maxb.y))
    for point in rest {
        maxPoint.x = max(maxPoint.x, point.x)
        maxPoint.y = max(maxPoint.y, point.y)
    }
    return maxPoint
}

extension CGPoint: Hashable {
    public var hashValue: Int {
        // iOS Swift Game Development Cookbook
        // https://gist.github.com/FredrikSjoberg/ced4ad5103863ab95dc8b49bdfd99eb2
        return x.hashValue << 32 ^ y.hashValue
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}

public extension CGPoint {
    var isZero: Bool {
        return self.equalTo(CGPoint.zero)
    }
    /**
     * Get point by rounding to nearest integer value
     */
    var integral: CGPoint {
        return CGPoint(
            x: CGFloat(Int(self.x >= 0.0 ? self.x + 0.5 : self.x - 0.5)),
            y: CGFloat(Int(self.y >= 0.0 ? self.y + 0.5 : self.y - 0.5))
        )
    }
    func distance(_ point: CGPoint) -> CGFloat {
        let diff = CGPoint(x: self.x - point.x, y: self.y - point.y)
        return CGFloat(sqrtf(Float(diff.x*diff.x + diff.y*diff.y)))
    }
    func projectLine( _ point: CGPoint, length: CGFloat) -> CGPoint {
        var newPoint = CGPoint(x: point.x, y: point.y)
        let locationX = (point.x - self.x)
        let locationY = (point.y - self.y)
        if x.floatingPointClass == .negativeZero {
            newPoint.y += length
        } else if y.floatingPointClass == .negativeZero {
            newPoint.x += length
        } else {
            #if CGFLOAT_IS_DOUBLE
                let angle = atan(locationY / locationX)
                newPoint.x += sin(angle) * length
                newPoint.y += cos(angle) * length
            #else
                let angle = atanf(Float(locationY) / Float(locationX))
                newPoint.x += CGFloat(sinf(angle) * Float(length))
                newPoint.y += CGFloat(cosf(angle) * Float(length))
            #endif
        }
        return newPoint
    }
}
public extension CGPoint {
    /// - returns: A `CGVector` with dx: x and dy: y.
    var vector: CGVector {
        return CGVector(dx: x, dy: y)
    }
    /// - returns: A `CGPoint` with rounded x and y values.
    var rounded: CGPoint {
        return CGPoint(x: round(x), y: round(y))
    }
    /// - returns: The Euclidean distance from self to the given point.
    //    public func distance(to point: CGPoint) -> CGFloat {
    //        return (point - self).magnitude
    //    }
    
    /// Constrains the x and y value to within the provided rect.
    //    public func clipped(to rect: CGRect) -> CGPoint {
    //        return CGPoint(x: x.clipped(rect.minX, rect.maxX),
    //            y: y.clipped(rect.minY, rect.maxY))
    //    }
    
    /// - returns: The relative position inside the provided rect.
    func position(in rect: CGRect) -> CGPoint {
        return CGPoint(x: x - rect.origin.x,
                       y: y - rect.origin.y)
    }
    /// - returns: The position inside the provided rect,
    /// where horizontal and vertical position are normalized
    /// (i.e. mapped to 0-1 range).
    func normalizedPosition(in rect: CGRect) -> CGPoint {
        let position = position(in: rect)
        return CGPoint(x: (1.0 / rect.width) * position.x,
                       y: (1.0 / rect.width) * position.y)
    }
    /// - returns: True if the line contains the point.
    func isAt(line: [CGPoint]) -> Bool {
        return line.contains(self)
    }
}
public extension CGPoint {
    func translate(_ originX: CGFloat, _ originY: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + originX, y: self.y + originY)
    }
    func translateX(_ originX: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + originX, y: self.y)
    }
    func translateY(_ originY: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: self.y + originY)
    }
    var invertY: CGPoint {
        return CGPoint(x: self.x, y: -self.y)
    }
    var xAxis: CGPoint {
        return CGPoint(x: 0, y: self.y)
    }
    var yAxis: CGPoint {
        return CGPoint(x: self.x, y: 0)
    }
    func add(_ otherPoint: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + otherPoint.x, y: self.y + otherPoint.y)
    }
    func addScalar(_ scalar: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + scalar, y: self.y + scalar)
    }
    func sub(_ otherPoint: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - otherPoint.x, y: self.y - otherPoint.y)
    }
    func subScalar(_ value: CGFloat) -> CGPoint {
        return CGPoint(x: self.x - value, y: self.y - value)
    }
    func deltaTo(_ value: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - value.x, y: self.y - value.y)
    }
    func multiplyBy(_ value: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * value, y: self.y * value)
    }
    func divByScalar(_ value: CGFloat) -> CGPoint {
        return CGPoint(x: self.x / value, y: self.y / value)
    }
    var length: CGFloat {
        return CGFloat(sqrt(CDouble(self.x*self.x + self.y*self.y)))
    }
    var normalize: CGPoint {
        let length = self.length
        return CGPoint(x: self.x / length, y: self.y / length)
    }
    static func fromString(_ string: String) -> CGPoint {
        var result = string.replacingOccurrences(of: "{", with: "")
        result = result.replacingOccurrences(of: "}", with: "")
        result = result.replacingOccurrences(of: " ", with: "")
        let originX = NSString(string: result.components(separatedBy: ",").first! as String).doubleValue
        let originY = NSString(string: result.components(separatedBy: ",").last! as String).doubleValue
        return CGPoint(x: CGFloat(originX), y: CGFloat(originY))
    }
    /// Get the mid point of the receiver with another passed point.
    ///
    /// - Parameter p2: other point.
    /// - Returns: mid point.
    func midPointForPointsTo(_ otherPoint: CGPoint) -> CGPoint {
        return CGPoint(x: (x + otherPoint.x) / 2, y: (y + otherPoint.y) / 2)
    }
    /// Control point to another point from receiver.
    ///
    /// - Parameter p2: other point.
    /// - Returns: control point for quad curve.
    func controlPointToPoint(_ point2: CGPoint) -> CGPoint {
        var controlPoint = self.midPointForPointsTo(point2)
        let  diffY = abs(point2.y - controlPoint.y)
        if self.y < point2.y {
            controlPoint.y += diffY
        } else if self.y > point2.y {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
    func equalsTo(_ compare: Self) -> Bool {
        return self.x == compare.x && self.y == compare.y
    }
    func distanceFrom(_ otherPoint: Self) -> CGFloat {
        let dxPoint = self.x - otherPoint.x
        let dyPoint = self.y - otherPoint.y
        return (dxPoint * dxPoint) + (dyPoint * dyPoint)
    }
    func distance(from lhs: CGPoint) -> CGFloat {
        return hypot(lhs.x.distance(to: self.x), lhs.y.distance(to: self.y))
    }
    func distanceToSegment(_ p1Segment: CGPoint, _ p2Segment: CGPoint) -> Float {
        var p1SegmentX = p1Segment.x
        var p1SegmentY = p1Segment.y
        var dxSegment = p2Segment.x - p1SegmentX
        var dySegment = p2Segment.y - p1SegmentY
        if dxSegment != 0 || dySegment != 0 {
            let segmentT = ((self.x - p1SegmentX) * dxSegment + (self.y - p1SegmentY) * dySegment) / (dxSegment * dxSegment + dySegment * dySegment)
            if segmentT > 1 {
                p1SegmentX = p2Segment.x
                p1SegmentY = p2Segment.y
            } else if segmentT > 0 {
                p1SegmentX += dxSegment * segmentT
                p1SegmentY += dySegment * segmentT
            }
        }
        dxSegment = self.x - p1SegmentX
        dySegment = self.y - p1SegmentY
        return Float(dxSegment * dxSegment + dySegment * dySegment)
    }
    func distanceToLine(from linePoint1: CGPoint, to linePoint2: CGPoint) -> CGFloat {
        let dxLine = linePoint2.x - linePoint1.x
        let dyLine = linePoint2.y - linePoint1.y
        let dividend = abs(dyLine * self.x - dxLine * self.y - linePoint1.x * linePoint2.y + linePoint2.x * linePoint1.y)
        let divisor = sqrt(dxLine * dxLine + dyLine * dyLine)
        return dividend / divisor
    }
    /**
     Averages the point with another.
     - parameter point: The point to average with.
     - returns: A point with an x and y equal to the average of this and the given point's x and y.
     */
    func average(with point: CGPoint) -> CGPoint {
        return CGPoint(x: (x + point.x) * 0.5, y: (y + point.y) * 0.5)
    }
    /**
     Calculates the difference in x and y between 2 points.
     - parameter point: The point to calculate the difference to.
     - returns: A point with an x and y equal to the difference between this and the given point's x and y.
     */
    func differential(to point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x - x, y: point.y - y)
    }
    /**
     Calculates the distance between two points.
     - parameter point: the point to calculate the distance to.
     - returns: A CGFloat of the distance between the points.
     */
    func distance(to point: CGPoint) -> CGFloat {
        return differential(to: point).hypotenuse
    }
    /**
     Calculates the hypotenuse of the x and y component of a point.
     - returns: A CGFloat for the hypotenuse of the point.
     */
    var hypotenuse: CGFloat {
        return sqrt(x * x + y * y)
    }
    func slopeTo(_ point: CGPoint) -> CGFloat {
        let delta = point.deltaTo(self)
        return delta.y / delta.x
    }
    func addTo(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
    func absoluteDeltaY(_ point: CGPoint) -> Double {
        return Double(abs(self.y - point.y))
    }
    func addX(_ value: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + value, y: self.y)
    }
    func belowLine(_ point1: CGPoint, point2: CGPoint) -> Bool {
        guard point1.x != point2.x else { return self.y < point1.y && self.y < point2.y }
        let point = point1.x < point2.x ? [point1, point2] : [point2, point1]
        if self.x == point[0].x {
            return self.y < point[0].y
        } else if self.x == point[1].x {
            return self.y < point[1].y
        }
        let delta = point[1].deltaTo(point[0])
        let slope = delta.y / delta.x
        let myDeltaX = self.x - point[0].x
        let pointOnLineY = slope * myDeltaX + point[0].y
        return self.y < pointOnLineY
    }
    func aboveLine(_ point1: CGPoint, point2: CGPoint) -> Bool {
        guard point1.x != point2.x else { return self.y > point1.y && self.y > point2.y }
        let point = point1.x < point2.x ? [point1, point2]: [point2, point1]
        if self.x == point[0].x {
            return self.y > point[0].y
        } else if self.x == point[1].x {
            return self.y > point[1].y
        }
        let delta = point[1].deltaTo(point[0])
        let slope = delta.y / delta.x
        let myDeltaX = self.x - point[0].x
        let pointOnLineY = slope * myDeltaX + point[0].y
        return self.y > pointOnLineY
    }
}

public extension CGPoint {
    
    enum CoordinateSide {
        case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left
    }
    
    static func unitCoordinate(_ side: CoordinateSide) -> CGPoint {
        switch side {
        case .topLeft:      return CGPoint(x: 0.0, y: 0.0)
        case .top:          return CGPoint(x: 0.5, y: 0.0)
        case .topRight:     return CGPoint(x: 1.0, y: 0.0)
        case .right:        return CGPoint(x: 0.0, y: 0.5)
        case .bottomRight:  return CGPoint(x: 1.0, y: 1.0)
        case .bottom:       return CGPoint(x: 0.5, y: 1.0)
        case .bottomLeft:   return CGPoint(x: 0.0, y: 1.0)
        case .left:         return CGPoint(x: 1.0, y: 0.5)
        }
    }
}
