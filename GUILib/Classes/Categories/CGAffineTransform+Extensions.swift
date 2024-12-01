//
//  CGAffineTransform+Extensions.swift
//  ExampleSwift
//
//  Created by Jorge Ouahbi
//  Copyright © 2000 Jorge Ouahbi. All rights reserved.
//

import UIKit

public extension CGAffineTransform {
    static func randomRotate() -> CGAffineTransform {
        return CGAffineTransform(rotationAngle: CGFloat((Double.random(in: 0..<1) * 360.0).degreesToRadians()))
    }
    static func randomScale(scaleXMax: CGFloat = 16, scaleYMax: CGFloat = 16) -> CGAffineTransform {
        let scaleX  = (CGFloat.random(in: 0..<1) *  scaleXMax) +  1.0
        let scaleY  = (CGFloat.random(in: 0..<1) *  scaleYMax) +  1.0
        let flip: CGFloat = CGFloat.random(in: 0..<1) < 0.5 ? -1 : 1
        return CGAffineTransform(scaleX: scaleX, y: scaleY * flip)
    }
}
