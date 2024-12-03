//
//  CAAnimation+Closure.swift
//  CAAnimation+Closures
//
//  Created by Honghao Zhang on 2/5/15.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import QuartzCore
import UIKit

extension CATransaction {
    public class func withDisabledActions<T>(_ body: () throws -> T) rethrows -> T {
        let actionsWereDisabled = CATransaction.disableActions()
        CATransaction.setDisableActions(true)
        defer {
            CATransaction.setDisableActions(actionsWereDisabled)
        }
        return try body()
    }
}
