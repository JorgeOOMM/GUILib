//
//  Date+Extensions.swift
//
//  Created by Jorge Ouahbi on 29/10/2020.
//  Copyright © 2020 dsp. All rights reserved.
//

import UIKit


extension DateFormatter {
    var shortMonthSymbols: [String] {
        return self.monthSymbols.map( {
            let firstCharIndex = $0.index( $0.startIndex, offsetBy: 3)
            return String($0[..<firstCharIndex]).capitalized
        })
    }
}

public extension Date {
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
    static var currentMonth: Int {
        return Calendar.current.dateComponents([.day, .month, .year], from: Date()).month ?? 0
    }
    static var currentDay: Int {
        return Calendar.current.dateComponents([.day, .month, .year], from: Date()).day ?? 0
    }
    static var currentYear: Int {
        return Calendar.current.dateComponents([.day, .month, .year], from: Date()).year ?? 0
    }
}
