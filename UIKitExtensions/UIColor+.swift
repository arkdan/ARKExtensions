//
//  UIColor.swift
//  UIKitExtensions
//
//  Created by ark dan on 4/5/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import UIKit


extension Int {
    fileprivate func rgb() -> (r: Int, g: Int, b: Int) {
        return (red, green, blue)
    }
    fileprivate var red: Int {
        return (self >> 16) & 0xff
    }
    fileprivate var green: Int {
        return (self >> 8) & 0xff
    }
    fileprivate var blue: Int {
        return self & 0xff
    }
}

extension UIColor {

    public convenience init(red255: CGFloatConvertible, green: CGFloatConvertible, blue: CGFloatConvertible, alpha: CGFloatConvertible = 1.0) {
        self.init(red: red255.cgFloat / 255.0,
                  green:green.cgFloat / 255.0,
                  blue: blue.cgFloat / 255.0,
                  alpha: alpha.cgFloat)
    }

    public func rgba255() -> (Double, Double, Double, Double) {
        let (r, g, b, a) = rgba()
        return (r * 255, g * 255, b * 255, a)
    }

    public func rgba() -> (Double, Double, Double, Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
    }

    // MARK: -

    public convenience init(hexString: String, alpha: Double = 1) {
        let string = hexString.trimming("#")
        let hex = strtol(string, nil, 16)
        self.init(red255: hex.red, green: hex.green, blue: hex.blue)
    }

    public func hex() -> Int {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: nil)
        return Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0
    }

    public func hexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: nil)
        let hex = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255) << 0

        return String(hex, radix: 16, uppercase: true)
    }
}

