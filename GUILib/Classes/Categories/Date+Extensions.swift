//
//  Date+Extensions.swift
//
//  Created by Jorge Ouahbi on 29/10/2020.
//  Copyright © 2020 dsp. All rights reserved.
//

import UIKit

extension Date {
    var mouthTimeElapsedPercent: CGFloat {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)
        let currentDay = components.day ?? 1
        let range = calendar.range(of: .day, in: .month, for: date)
        let numberOfDaysInMouth = range!.count
        let displacementInSection: CGFloat = CGFloat(1.0) / CGFloat(numberOfDaysInMouth) * CGFloat(currentDay)
        return displacementInSection
    }
}
