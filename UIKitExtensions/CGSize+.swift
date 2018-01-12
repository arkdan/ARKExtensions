//
//  CGSize+.swift
//  PhotoStory
//
//  Created by mac on 12/8/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import UIKit

extension CGRect {

    public static func withSize(_ size: CGSize) -> CGRect {
        return CGRect(origin: .zero, size: size)
    }
}

extension CGSize {

    public init(_ w: CGFloatConvertible, _ h: CGFloatConvertible) {
        self.init(width: w.cgFloat, height: h.cgFloat)
    }

    public mutating func scale(x: CGFloatConvertible, y: CGFloatConvertible) {
        width *= x.cgFloat
        height *= y.cgFloat
    }

    public func scaled(x: CGFloatConvertible, y: CGFloatConvertible) -> CGSize {
        var copy = self
        copy.scale(x: x, y: y)
        return copy
    }

    public func scaleFactorAspectFit(in target: CGSize) -> CGFloat {
        // try to match width
        let scale = target.width / self.width;
        // if we scale the height to make the widths equal, does it still fit?
        if height * scale <= target.height {
            return scale
        }
        // no, match height instead
        return target.height / height
    }

    public func scaledAspectFit(in target: CGSize) -> CGSize {
        let scale = scaleFactorAspectFit(in: target)
        let w = width * scale
        let h = height * scale
        return CGSize(width: w, height: h)
    }

    public static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    public static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}

extension CGPoint {
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
