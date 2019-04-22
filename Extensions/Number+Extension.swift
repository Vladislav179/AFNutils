//
//  Int+Extension.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

extension Int {

    func stringTime() -> String {
        let date1 = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter1 = DateFormatter()
        dateFormatter1.timeZone = TimeZone.current

        dateFormatter1.locale = NSLocale.current
        dateFormatter1.dateFormat = "h:mm a" //Specify your format that you want
        let strDate1 = dateFormatter1.string(from: date1)

        return strDate1
    }

    func stringTimeAgo() -> String {

        let date1 = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter1 = DateFormatter()
        dateFormatter1.timeZone = TimeZone.current
        dateFormatter1.locale = NSLocale.current
        dateFormatter1.dateFormat = "MMM d, h:mm a"
        let strDate1 = dateFormatter1.string(from: date1)

        return strDate1
    }

    func date() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}

extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }

    static func randomNumberWith(digits:Int) -> Int {
        let min = Int(pow(Double(10), Double(digits-1))) - 1
        let max = Int(pow(Double(10), Double(digits))) - 1
        return Int(Range(uncheckedBounds: (min, max)))
    }
}

extension CGFloat {
    func abs() -> CGFloat {
        return CGFloat(Swift.abs(self))
    }
}
