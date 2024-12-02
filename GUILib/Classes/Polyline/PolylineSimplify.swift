//
//  PolylineSimplify.swift
//
//  Created by Jorge Ouahbi on 27/08/2020.
//  Copyright © 2022 dsp. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol SimplifyValue {
    var xValue: Double { get }
    var yValue: Double { get }
}

func equalsPoints<T: SimplifyValue>(left: T, right: T) -> Bool {
    return left.xValue == right.xValue && left.yValue == right.yValue
}

extension CGPoint: SimplifyValue {
    public var xValue: Double {
        return Double(x)
    }
    public var yValue: Double {
        return Double(y)
    }
}

open class PolylineSimplify {
    /**
     Calculate square distance
     
     - parameter pointA: from point
     - parameter pointB: to point
     
     - returns: square distance between two points
     */
    fileprivate class func getSquareDistance<T: SimplifyValue>(_ pointA: T,_ pointB: T) -> Float {
        return Float((pointA.xValue - pointB.xValue) * (pointA.xValue - pointB.xValue) + (pointA.yValue - pointB.yValue) * (pointA.yValue - pointB.yValue))
    }
    
    /**
     Calculate square distance from a point to a segment
     
     - parameter point: from point
     - parameter seg1: segment first point
     - parameter seg2: segment last point

     - returns: square distance between point to a segment
     */
    fileprivate class func getSquareSegmentDistance<T: SimplifyValue>( point: T, seg1: T, seg2: T) -> Float {
        
        var seg1X = seg1.xValue
        var seg1Y = seg1.yValue
        var seg2dx = seg2.xValue - seg1X
        var seg2dy = seg2.yValue - seg1Y
        
        if seg2dx != 0 || seg2dy != 0 {
            let segT = ((point.xValue - seg1X) * seg2dx + (point.yValue - seg1Y) * seg2dy) / ((seg2dx * seg2dx) + (seg2dy * seg2dy))
            if segT > 1 {
                seg1X = seg2.xValue
                seg1Y = seg2.yValue
            } else if segT > 0 {
                seg1X += seg2dx * segT
                seg1Y += seg2dy * segT
            }
        }
        
        seg2dx = point.xValue - seg1X
        seg2dy = point.yValue - seg1Y
        
        return Float((seg2dx * seg2dx) + (seg2dy * seg2dy))
    }
    
    /**
     Simplify an array of points using the Ramer-Douglas-Peucker algorithm
     
     - parameter points:      An array of points
     - parameter tolerance:   Affects the amount of simplification (in the same metric as the point coordinates)
     
     - returns: Returns an array of simplified points
     */
    fileprivate class func simplifyDouglasPeucker<T: SimplifyValue>(_ points: [T], tolerance: Float!) -> [T] {
        if points.count <= 2 {
            return points
        }
        
        let lastPoint: Int = points.count - 1
        var result: [T] = [points.first!]
        simplifyDouglasPeuckerStep(points, first: 0, last: lastPoint, tolerance: tolerance, simplified: &result)
        result.append(points[lastPoint])
        return result
    }
    
    fileprivate class func simplifyDouglasPeuckerStep<T: SimplifyValue>(_ points: [T], first: Int, last: Int, tolerance: Float, simplified: inout [T]) {
        var maxSquareDistance = tolerance
        var index = 0
        
        for curIndex in first + 1 ..< last {
            let sqDist = getSquareSegmentDistance(point: points[curIndex], seg1: points[first], seg2: points[last])
            if sqDist > maxSquareDistance {
                index = curIndex
                maxSquareDistance = sqDist
            }
        }
        
        if maxSquareDistance > tolerance {
            if index - first > 1 {
                simplifyDouglasPeuckerStep(points, first: first, last: index, tolerance: tolerance, simplified: &simplified)
            }
            simplified.append(points[index])
            if last - index > 1 {
                simplifyDouglasPeuckerStep(points, first: index, last: last, tolerance: tolerance, simplified: &simplified)
            }
        }
    }
    
    /**
     Simplify an array of points using the Radial Distance algorithm
     
     - parameter points:      An array of points
     - parameter tolerance:   Affects the amount of simplification (in the same metric as the point coordinates)
     
     - returns: Returns an array of simplified points
     */
    fileprivate class func simplifyRadialDistance<T:SimplifyValue>(_ points: [T], tolerance: Float!) -> [T] {
        if points.count <= 2 {
            return points
        }
        
        var prevPoint: T = points.first!
        var newPoints: [T] = [prevPoint]
        var point: T = points[1]
        
        for idx in 1 ..< points.count {
            point = points[idx]
            let distance = getSquareDistance(point, prevPoint)
            if distance > tolerance! {
                newPoints.append(point)
                prevPoint = point
            }
        }
        
        if !equalsPoints(left: prevPoint, right: point) {
            newPoints.append(point)
        }
        
        return newPoints
    }
    
    /**
     Returns an array of simplified points
     
     - parameter points:      An array of points
     - parameter tolerance:   Affects the amount of simplification (in the same metric as the point coordinates)
     - parameter highQuality: Excludes distance-based preprocessing step which leads to highest quality simplification but runs ~10-20 times slower
     
     - returns: Returns an array of simplified points
     */
    
    open class func simplify<T:SimplifyValue>(_ points: [T], tolerance: Float?, highQuality: Bool = false) -> [T] {
        if points.count <= 2 {
            return points
        }
        let squareTolerance = (tolerance != nil ? tolerance! * tolerance! : 1.0)
        var result: [T] = (highQuality == true ? points : simplifyRadialDistance(points, tolerance: squareTolerance))
        result = simplifyDouglasPeucker(result, tolerance: squareTolerance)
        return result
    }
}
