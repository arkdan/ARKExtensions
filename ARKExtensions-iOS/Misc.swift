//
//  Misc.swift
//  ARKExtensions
//
//  Created by ark dan on 11/16/16.
//  Copyright © 2016 arkdan. All rights reserved.
//

import UIKit

extension UIStoryboard {
    @nonobjc public static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
extension UIStoryboard {
    public func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T {
        return instantiateViewController(withIdentifier: type.identifier) as! T
    }
}

extension UIViewController {
    public class var identifier: String {
        return String(describing: self)
    }
}

@objc public class TapGestureRecognizer: UITapGestureRecognizer {
    private let action: (TapGestureRecognizer) -> ()
    public init(action: @escaping (TapGestureRecognizer) -> ()) {
        self.action = action
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(onTap(sender:)))
    }

    @objc private func onTap(sender: TapGestureRecognizer) {
        action(self)
    }
}

extension UIPickerView {
    public class var height: CGFloat {
        return 216
    }
}

extension UIColor {
    public convenience init(red255: Int, green: Int, blue: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat(red255) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: CGFloat(alpha))
    }

    @nonobjc public static func fromHex(_ hex: Int, alpha: Double = 1) -> UIColor {
        return UIColor(red255: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff)

    }

    public func hex() -> Int {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        return (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
    }
}

extension UIColor {

    @nonobjc public static let hexes: [Int] = {
        let path = Bundle.main.path(forResource: "Colors", ofType: "plist")!
        let ddd = NSArray(contentsOfFile: path)
        guard let arr = ddd as? [Int] else {
            return []
        }
        return arr
    }()

    public static var newPurple: UIColor {
        return UIColor(red255: 155, green: 47, blue: 174)
    }
    public static var newRed: UIColor {
        return UIColor(red255: 241, green: 69, blue: 61)
    }
    public static var teal: UIColor {
        return UIColor(red255: 21, green: 149, blue: 136)
    }
    public static var indigo: UIColor {
        return UIColor(red255: 64, green: 84, blue: 178)
    }

    public static var random: UIColor {
        guard hexes.count > 0 else {
            fatalError()
        }
        let randomHex = hexes[Int(arc4random_uniform(UInt32(hexes.count - 1)))]
        return fromHex(randomHex)
    }
}
