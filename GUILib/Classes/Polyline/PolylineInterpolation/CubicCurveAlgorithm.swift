// Copyright 2018 Jorge Ouahbi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  CubicCurveAlgorithm.swift
//  Bezier
//
//  Created by Ramsundar Shandilya on 10/12/15.
//  Copyright © 2015 Y Media Labs. All rights reserved.
//

import Foundation
import UIKit

// https://exploringswift.com/blog/Drawing-Smooth-Cubic-Bezier-Curve-through-prescribed-points-using-Swift
struct CubicCurveSegment {
    var firstControlPoint: CGPoint
    var secondControlPoint: CGPoint
}
class CubicCurveAlgorithm {
    var firstControlPoints: [CGPoint?] = []
    var secondControlPoints: [CGPoint?] = []
    func controlPointsFromPoints(data: [CGPoint]) -> [CubicCurveSegment] {
        let segments = data.count - 1
        if segments == 1 {
            // straight line calculation here
            let firstControlPoint = data[0]
            let secondControlPoint = data[1]
            return [CubicCurveSegment(firstControlPoint: firstControlPoint, secondControlPoint: secondControlPoint)]
        } else if segments > 1 {
            // Left hand side coefficients
            var adSide = [CGFloat]()
            var dSide = [CGFloat]()
            var bdSide = [CGFloat]()
            var rhsArray = [CGPoint]()
            for index in 0..<segments {
                var rhsXValue: CGFloat = 0
                var rhsYValue: CGFloat = 0
                let firstControlPoint = data[index]
                let secondControlPoint = data[index+1]
                if index == 0 {
                    bdSide.append(0.0)
                    dSide.append(2.0)
                    adSide.append(1.0)
                    rhsXValue = firstControlPoint.x + 2*secondControlPoint.x
                    rhsYValue = firstControlPoint.y + 2*secondControlPoint.y
                } else if index == segments - 1 {
                    bdSide.append(2.0)
                    dSide.append(7.0)
                    adSide.append(0.0)
                    rhsXValue = 8*firstControlPoint.x + secondControlPoint.x
                    rhsYValue = 8*firstControlPoint.y + secondControlPoint.y
                } else {
                    bdSide.append(1.0)
                    dSide.append(4.0)
                    adSide.append(1.0)
                    rhsXValue = 4*firstControlPoint.x + 2*secondControlPoint.x
                    rhsYValue = 4*firstControlPoint.y + 2*secondControlPoint.y
                }
                rhsArray.append(CGPoint(x: rhsXValue, y: rhsYValue))
            }
            return thomasTridiagonalMatrixAlgorithm(bdSide: bdSide,
                                                    dSide: dSide,
                                                    adSide: adSide,
                                                    rhsArray: rhsArray,
                                                    segments: segments,
                                                    data: data)
        }
        return []
    }
    
    /// Thomas TridiagonalM atrix Algorithm
    /// - Parameters:
    ///   - bdSide: [CGFloat]
    ///   - dSide: [CGFloat]
    ///   - adSide: [CGFloat]
    ///   - rhsArray: [CGFloat]
    ///   - segments: Number of segments
    ///   - data: [CGPoint]
    /// - Returns: [CubicCurveSegment]
    internal func thomasTridiagonalMatrixAlgorithm(bdSide: [CGFloat],
                                                   dSide: [CGFloat],
                                                   adSide: [CGFloat],
                                                   rhsArray: [CGPoint],
                                                   segments: Int,
                                                   data: [CGPoint]) -> [CubicCurveSegment] {
        
        var controlPoints: [CubicCurveSegment] = []
        var adSide = adSide
        let bdSide = bdSide
        let dSide = dSide
        var rhsArray = rhsArray
        let segments = segments
        
        var solutionSet1 = [CGPoint?]()
        solutionSet1 = Array(repeating: nil, count: segments)
        
        //First segment
        adSide[0] /= dSide[0]
        rhsArray[0].x /= dSide[0]
        rhsArray[0].y /= dSide[0]
        
        //Middle Elements
        if segments > 2 {
            for index in 1...segments - 2  {
                let rhsValueX = rhsArray[index].x
                let prevRhsValueX = rhsArray[index - 1].x
                
                let rhsValueY = rhsArray[index].y
                let prevRhsValueY = rhsArray[index - 1].y
                
                adSide[index] /= (dSide[index] - bdSide[index]*adSide[index-1]);
                
                let exp1x = (rhsValueX - (bdSide[index]*prevRhsValueX))
                let exp1y = (rhsValueY - (bdSide[index]*prevRhsValueY))
                let exp2 = (dSide[index] - bdSide[index]*adSide[index-1])
                
                rhsArray[index].x = exp1x / exp2
                rhsArray[index].y = exp1y / exp2
            }
        }
        
        // Last Element
        let lastElementIndex = segments - 1
        let exp1 = (rhsArray[lastElementIndex].x - bdSide[lastElementIndex] * rhsArray[lastElementIndex - 1].x)
        let exp1y = (rhsArray[lastElementIndex].y - bdSide[lastElementIndex] * rhsArray[lastElementIndex - 1].y)
        let exp2 = (dSide[lastElementIndex] - bdSide[lastElementIndex] * adSide[lastElementIndex - 1])
        rhsArray[lastElementIndex].x = exp1 / exp2
        rhsArray[lastElementIndex].y = exp1y / exp2
        
        solutionSet1[lastElementIndex] = rhsArray[lastElementIndex]
        
        for index in (0..<lastElementIndex).reversed() {
            let controlPointX = rhsArray[index].x - (adSide[index] * solutionSet1[index + 1]!.x)
            let controlPointY = rhsArray[index].y - (adSide[index] * solutionSet1[index + 1]!.y)
            
            solutionSet1[index] = CGPoint(x: controlPointX, y: controlPointY)
        }
        
        firstControlPoints = solutionSet1
        
        for index in (0..<segments) {
            if index == (segments - 1) {
                
                let lastDataPoint = data[index + 1]
                let p1 = firstControlPoints[index]
                guard let controlPoint1 = p1 else { continue }
                
                let controlPoint2X = (0.5)*(lastDataPoint.x + controlPoint1.x)
                let controlPoint2y = (0.5)*(lastDataPoint.y + controlPoint1.y)
                
                let controlPoint2 = CGPoint(x: controlPoint2X, y: controlPoint2y)
                secondControlPoints.append(controlPoint2)
            } else {
                
                let dataPoint = data[index+1]
                let p1 = firstControlPoints[index+1]
                guard let controlPoint1 = p1 else { continue }
                
                let controlPoint2X = 2*dataPoint.x - controlPoint1.x
                let controlPoint2Y = 2*dataPoint.y - controlPoint1.y
                
                secondControlPoints.append(CGPoint(x: controlPoint2X, y: controlPoint2Y))
            }
        }
        for index in (0..<segments) {
            guard let firstCP = firstControlPoints[index] else { continue }
            guard let secondCP = secondControlPoints[index] else { continue }
            
            let segmentControlPoint = CubicCurveSegment(firstControlPoint: firstCP, secondControlPoint: secondCP)
            controlPoints.append(segmentControlPoint)
        }
        return controlPoints
    }
}
