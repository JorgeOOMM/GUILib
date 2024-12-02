//
//    Copyright 2020 - Jorge Ouahbi
//
//   Licensed under the Apache License, Version 2.0 (the "License")
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
//  Stadistics.swift
//
//  Created by Jorge Ouahbi
//  Copyright © 2024 Jorge Ouahbi. All rights reserved.
//

import Accelerate

public class Stadistics {
    public class func mean(_ lhs: [Float]) -> Float {
        var result: Float = 0
        vDSP_meanv(lhs, 1, &result, vDSP_Length(lhs.count))
        return result
    }
    public class func measq(_ lhs: [Float]) -> Float {
        var result: Float = 0
        vDSP_measqv(lhs, 1, &result, vDSP_Length(lhs.count))
        return result
    }
    public class func linregress(_ lhs: [Float], _ rhs: [Float]) -> (slope: Float, intercept: Float) {
        precondition(lhs.count == rhs.count, "Vectors must have equal count")
        let meanx = mean(lhs)
        let meany = mean(rhs)
        var result: [Float] = [Float].init(repeating: 0, count: lhs.count)
        vDSP_vmul(lhs, 1, rhs, 1, &result, 1, vDSP_Length(lhs.count))
        let meanxy = mean(result)
        let meanxSqr = measq(lhs)
        let slope = (meanx * meany - meanxy) / (meanx * meanx - meanxSqr)
        let intercept = meany - slope * meanx
        return (slope, intercept)
    }
}
