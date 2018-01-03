//
//  CGSize+.swift
//  PhotoStory
//
//  Created by mac on 12/8/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import UIKit

extension CGSize {
    public init(_ w: CGFloatConvertible, _ h: CGFloatConvertible) {
        self.init(width: w.cgFloat, height: h.cgFloat)
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
