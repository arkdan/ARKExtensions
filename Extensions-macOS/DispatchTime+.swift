//
//  DispatchTime+.swift
//  ARKExtensions
//
//  Created by mac on 1/3/18.
//  Copyright © 2018 arkdan. All rights reserved.
//

import Foundation

extension DispatchTimeInterval {
    public static func withSeconds(_ seconds: Double) -> DispatchTimeInterval {
        return DispatchTimeInterval.nanoseconds(Int(seconds * 1e9))
    }
}

extension DispatchTime {
    static public func fromNow(seconds: Double) -> DispatchTime {
        return DispatchTime.now() + DispatchTimeInterval.withSeconds(seconds)
    }
}

public func delay(_ time: Double, queue: DispatchQueue = DispatchQueue.main, block: @escaping () -> ()) {
    queue.asyncAfter(deadline: DispatchTime.fromNow(seconds: time), execute: block)
}

extension DispatchQueue {
    public func delayed(_ time: Double, block: @escaping () -> ()) {
        asyncAfter(deadline: DispatchTime.fromNow(seconds: time), execute: block)
    }
}

