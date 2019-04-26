//
//  UIColor+Extensions.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation

extension UIColor {
    convenience init(r: UInt8, g: UInt8 , b: UInt8 , a: UInt8) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(a)/255)
    }
    convenience init(r: Double, g: Double , b: Double , alpha: Double) {
        self.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(alpha))
    }
}
