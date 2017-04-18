//
//  CGFloatConvertible.swift
//  ARKExtensions
//
//  Created by ark dan on 4/19/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation


public protocol CGFloatConvertible {
    var cgFloat: CGFloat { get }
}





extension Double: CGFloatConvertible {
    public var cgFloat: CGFloat { return CGFloat(self) }
}
extension Int: CGFloatConvertible {
    public var cgFloat: CGFloat { return CGFloat(self) }
}
extension UInt: CGFloatConvertible {
    public var cgFloat: CGFloat { return CGFloat(self) }
}
extension CGFloat: CGFloatConvertible {
    public var cgFloat: CGFloat { return self }
}

