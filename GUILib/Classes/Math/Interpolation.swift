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
//  Interpolation.swift
//
//  Created by Jorge Ouahbi on 13/5/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//

import UIKit
/// Interpolation type: http://paulbourke.net/miscellaneous/interpolation/
///
/// - linear: lineal interpolation
/// - exponential: exponential interpolation
/// - cosine: cosine interpolation
/// - cubic: cubic interpolation
/// - bilinear: bilinear interpolation
enum InterpolationType {
    case linear
    case exponential
    case cosine
    case cubic
    case bilinear
}
// MARK: - Interpolation class
class Interpolation {
    /// Cubic Interpolation
    ///
    /// - Parameters:
    ///   - y0: element 0
    ///   - y1: element 1
    ///   - y2: element 2
    ///   - y3: element 3
    ///   - alpha: alpha
    /// - Returns: the interpolate value
    /// - Note:
    /// Paul Breeuwsma proposes the following coefficients for a smoother interpolated curve,
    /// which uses the slope between the previous point and the next as the derivative at the current point.
    /// This results in what are generally referred to as Catmull-Rom splines.
    ///  a0 = -0.5*y0 + 1.5*y1 - 1.5*y2 + 0.5*y3;
    ///  a1 = y0 - 2.5*y1 + 2*y2 - 0.5*y3;
    ///  a2 = -0.5*y0 + 0.5*y2;
    ///  a3 = y1;
    
    class func cubicerp(_ cubicerpy0: CGFloat,
                        cubicerpy1: CGFloat,
                        cubicerpy2: CGFloat,
                        cubicerpy3: CGFloat,
                        alpha: CGFloat) -> CGFloat {
        var cubicerpa0: CGFloat
        var cubicerpa1: CGFloat
        var cubicerpa2: CGFloat
        var cubicerpa3: CGFloat
        var cubicerpt2: CGFloat
        assert(alpha >= 0.0 && alpha <= 1.0)
        cubicerpt2 = alpha*alpha
        cubicerpa0 = cubicerpy3 - cubicerpy2 - cubicerpy0 + cubicerpy1
        cubicerpa1 = cubicerpy0 - cubicerpy1 - cubicerpa0
        cubicerpa2 = cubicerpy2 - cubicerpy0
        cubicerpa3 = cubicerpy1
        return(cubicerpa0*alpha*cubicerpt2+cubicerpa1*cubicerpt2+cubicerpa2*alpha+cubicerpa3)
    }
    /// Exponential Interpolation
    ///
    /// - Parameters:
    ///   - y0: element 0
    ///   - y1: element 1
    ///   - alpha: alpha
    /// - Returns: the interpolate value
    class func eerp(_ eerpy0: CGFloat,
                    eerpy1: CGFloat,
                    alpha: CGFloat) -> CGFloat {
        assert(alpha >= 0.0 && alpha <= 1.0)
        let end    = log(max(Double(eerpy0), 0.01))
        let start  = log(max(Double(eerpy1), 0.01))
        return   CGFloat(exp(start - (end + start) * Double(alpha)))
    }
    /// Linear Interpolation
    ///
    /// - Parameters:
    ///   - y0: element 0
    ///   - y1: element 1
    ///   - alpha: alpha
    /// - Returns: the interpolate value
    /// - Note:
    ///  Imprecise method which does not guarantee v = v1 when alpha = 1, due to floating-point arithmetic error.
    ///  This form may be used when the hardware has a native Fused Multiply-Add instruction.
    ///  return v0 + alpha*(v1-v0);
    ///
    ///  Precise method which guarantees v = v1 when alpha = 1.
    ///  (1-alpha)*v0 + alpha*v1;
    class func lerp(_ lerpy0: CGFloat,
                    lerpy1: CGFloat,
                    alpha: CGFloat) -> CGFloat {
        assert(alpha >= 0.0 && alpha <= 1.0)
        let inverse = 1.0 - alpha
        return inverse * lerpy0 + alpha * lerpy1
    }
    /// Bilinear Interpolation
    ///
    /// - Parameters:
    ///   - y0: element 0
    ///   - y1: element 1
    ///   - t1: alpha
    ///   - y2: element 2
    ///   - y3: element 3
    ///   - t2: alpha
    /// - Returns: the interpolate value
    class func bilerp(_ bilerpy0: CGFloat,
                      bilerpy1: CGFloat,
                      bilerpt1: CGFloat,
                      bilerpy2: CGFloat,
                      bilerpy3: CGFloat,
                      bilerpt2: CGFloat) -> CGFloat {
        assert(bilerpt1 >= 0.0 && bilerpt1 <= 1.0)
        assert(bilerpt2 >= 0.0 && bilerpt2 <= 1.0)
        return lerp(lerp(bilerpy0, lerpy1: bilerpy1, alpha: bilerpt1), 
                    lerpy1: lerp(bilerpy2, lerpy1: bilerpy3, alpha: bilerpt2),
                    alpha: 0.5)
    }
    /// Cosine Interpolation
    ///
    /// - Parameters:
    ///   - y0: element 0
    ///   - y1: element 1
    ///   - alpha: alpha
    /// - Returns: the interpolate value
    class func coserp(_ coserpy0: CGFloat, 
                      coserpy1: CGFloat,
                      alpha: CGFloat) -> CGFloat {
        assert(alpha >= 0.0 && alpha <= 1.0)
        let mu2 = CGFloat(1.0-cos(Double(alpha) * .pi))/2
        return (coserpy0*(1.0-mu2)+coserpy1*mu2)
    }
}
