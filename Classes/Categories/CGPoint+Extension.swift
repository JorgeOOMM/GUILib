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
public func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
    return lhs.equalTo(rhs)
}

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
    //    public var hashValue: Int {
    //        return self.x.hashValue << MemoryLayout<CGFloat>.size ^ self.y.hashValue
    //    }
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
