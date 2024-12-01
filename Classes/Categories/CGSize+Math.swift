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
//  CGSize+Math.swift
//
//  Created by Jorge Ouahbi
//  Copyright © 2020 Jorge Ouahbi. All rights reserved.
//
import UIKit

/**
 * ...
 * a + b
 */
public func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width + right.width, height: left.height + right.height)
}

/**
 * ...
 * a += b
 */
public func += (left: inout CGSize, right: CGSize) {
    left = left + right
}

/**
 * ...
 * a - b
 */
public func - (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width - right.width, height: left.height - right.height)
}

/**
 * ...
 * a -= b
 */
public func -= (left: inout CGSize, right: CGSize) {
    left = left - right
}

/**
 * ...
 * a * b
 */
public func * (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width * right.width, height: left.height * right.height)
}

/**
 * ...
 * a *= b
 */
public func *= (left: inout CGSize, right: CGSize) {
    left = left * right
}

/**
 * ...
 * a / b
 */
public func / (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width / right.width, height: left.height / right.height)
}

/**
 * ...
 * a /= b
 */
public func /= (left: inout CGSize, right: CGSize) {
    left = left / right
}

/**
 * ...
 * a + c
 */
public func + (left: CGSize, right: CGPoint) -> CGSize {
    return CGSize(width: left.width + right.x, height: left.height + right.y)
}

/**
 * ...
 * a += c
 */
public func += (left: inout CGSize, right: CGPoint) {
    left = left + right
}

/**
 * ...
 * a - c
 */
public func - (left: CGSize, right: CGPoint) -> CGSize {
    return CGSize(width: left.width - right.x, height: left.height - right.y)
}

/**
 * ...
 * a -= c
 */
public func -= (left: inout CGSize, right: CGPoint) {
    left = left - right
}

/**
 * ...
 * a * c
 */
public func * (left: CGSize, right: CGPoint) -> CGSize {
    return CGSize(width: left.width * right.x, height: left.height * right.y)
}

/**
 * ...
 * a *= c
 */
public func *= (left: inout CGSize, right: CGPoint) {
    left = left * right
}

/**
 * ...
 * a / c
 */
public func / (left: CGSize, right: CGPoint) -> CGSize {
    return CGSize(width: left.width / right.x, height: left.height / right.y)
}

/**
 * ...
 * a /= c
 */
public func /= (left: inout CGSize, right: CGPoint) {
    left = left / right
}

/**
 * ...
 * a * 4.6
 */
public func * (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}

/**
 * ...
 * a - 4.6
 */
public func - (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width - right, height: left.height - right)
}

/**
 * ...
 * a - 4.6
 */
public func / (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width / right, height: left.height / right)
}

/**
 * ...
 * a - 4.6
 */
public func + (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width + right, height: left.height + right)
}

/**
 * ...
 * a *= 4.6
 */
public func *= (left: inout CGSize, right: CGFloat) {
    left = left * right
}

/**
*  @brief  CGSize Extension
*/
public extension CGSize {
    /// Get minimun value of CGSize
    var min: CGFloat {
        return Swift.min(height, width)
    }
    /// Get maximun value of CGSize
    var max: CGFloat {
        return Swift.max(height, width)
    }
    /// Get CGSize with the  maximun value
    func max(_ other: CGSize) -> CGSize {
        return self.max >= other.max ? self : other
    }
    var hypot: CGFloat {
        return CoreGraphics.hypot(height, width)
    }
    /// Center a CGPoint with a CGSize
    var center: CGPoint {
        return CGPoint(x: width * 0.5, y: height * 0.5)
    }
    /// Get a integral value of a CGSize
    var integral: CGSize {
        return CGSize(width: round(width), height: round(height))
    }
}
