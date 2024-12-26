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
//  CGRect+Estensions.swift
//
//  Created by Jorge Ouahbi
//  Copyright © 2020 Jorge Ouahbi. All rights reserved.
//
import UIKit
/**
 * CGRect
 */

/**
 * ...
 * a + b
 */
func + (left: CGRect, right: CGPoint) -> CGRect {
    return CGRect(x: left.origin.x + right.x, y: left.origin.y + right.y,
                  width: left.size.width, height: left.size.height)
}

/**
 * ...
 * a += b
 */
func += (left: inout CGRect, right: CGPoint) {
    left = left + right
}

/**
 * ...
 * a - b
 */
func - (left: CGRect, right: CGPoint) -> CGRect {
    return CGRect(x: left.origin.x - right.x, y: left.origin.y - right.y,
                  width: left.size.width, height: left.size.height)
}

/**
 * ...
 * a -= b
 */
func -= (left: inout CGRect, right: CGPoint) {
    left = left - right
}

/**
 * ...
 * a * 2.5
 */
func * (left: CGRect, right: CGFloat) -> CGRect {
    return CGRect(x: left.origin.x * right, y: left.origin.y * right,
                  width: left.size.width * right, height: left.size.height * right)
}

/**
 * ...
 * a *= 2.5
 */
func *= (left: inout CGRect, right: CGFloat) {
    left = left * right
}
/**
 * ...
 * a / 4.0
 */
func / (left: CGRect, right: CGFloat) -> CGRect {
    return CGRect(x: left.origin.x / right, y: left.origin.y / right,
                  width: left.size.width / right, height: left.size.height / right)
}
/**
 * ...
 * a /= 4.0
 */
func /= (left: inout CGRect, right: CGFloat) {
    left = left / right
}

/// Other utils

func rectGetCenter(_ rect: CGRect) -> CGPoint {
    return CGPoint(x: rect.midX, y: rect.midY)
}
func sizeScaleByFactor(_ aSize: CGSize, factor: CGFloat) -> CGSize {
    return CGSize(width: aSize.width * factor, height: aSize.height * factor)
}
func aspectScaleFit(_ sourceSize: CGSize, destRect: CGRect) -> CGFloat {
    let  destSize = destRect.size
    let scaleW = destSize.width / sourceSize.width
    let scaleH = destSize.height / sourceSize.height
    return min(scaleW, scaleH)
}
func rectAroundCenter(_ center: CGPoint, size: CGSize) -> CGRect {
    let halfWidth = size.width / 2.0
    let halfHeight = size.height / 2.0
    return CGRect(x: center.x - halfWidth, y: center.y - halfHeight,
                  width: size.width, height: size.height)
}
func rectByFittingRect(sourceRect: CGRect, destinationRect: CGRect) -> CGRect {
    let aspect = aspectScaleFit(sourceRect.size, destRect: destinationRect)
    let  targetSize = sizeScaleByFactor(sourceRect.size, factor: aspect)
    return rectAroundCenter(rectGetCenter(destinationRect), size: targetSize)
}

extension CGRect {
    /**
     * Extend CGRect by CGPoint
     */
    mutating func union(withPoint: CGPoint) {
        if withPoint.x < self.origin.x { self.size.width += self.origin.x - withPoint.x; self.origin.x = withPoint.x }
        if withPoint.y < self.origin.y { self.size.height += self.origin.y - withPoint.y; self.origin.y = withPoint.y }
        if withPoint.x > self.origin.x + self.size.width { self.size.width = withPoint.x - self.origin.x }
        if withPoint.y > self.origin.y + self.size.height { self.size.height = withPoint.y - self.origin.y; }
    }
    /**
     * Get end point of CGRect
     */
    var max: CGPoint {
        return CGPoint(x: self.maxX, y: self.maxY)
    }
    var  min: CGPoint {
        return CGPoint(x: self.minX, y: self.minY)
    }
    var  mid: CGPoint {
         return CGPoint(x: self.midX, y: self.midY)
     }
}
extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.origin.x)
        hasher.combine(self.origin.y)
        hasher.combine(self.size.width)
        hasher.combine(self.size.height)
    }
}
