//
//  DispatchClock.swift
//  ARKExtensions
//
//  Created by ark dan on 1/31/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation

public class DispatchClock {

    public var timeInterval: Double {
        didSet {
            if timeInterval < 1e-6 {
                timeInterval = 1e-6
                return
            }
            if timeInterval != oldValue {
                restart()
            }
        }
    }

    public let queue: DispatchQueue
    public var block: ((DispatchClock) -> Void)?

    fileprivate var dispatchSourceTimer: DispatchSourceTimer?


    public init(timeInterval: Double, queue: DispatchQueue, block: ((DispatchClock) -> Void)? = nil) {
        self.timeInterval = timeInterval >= 1e-6 ? timeInterval : 1e-6
        self.queue = queue
        self.block = block

        restart()
    }

    deinit {
        dispatchSourceTimer?.cancel()
        dispatchSourceTimer = nil
    }

    public func cancel() {
        dispatchSourceTimer?.cancel()
    }

    private func restart() {
        dispatchSourceTimer?.cancel()
        dispatchSourceTimer = nil

        dispatchSourceTimer = DispatchSource.makeTimerSource(queue: queue)
        let interval = DispatchTimeInterval.nanoseconds(Int(timeInterval * 1e9))
        let leeway = DispatchTimeInterval.nanoseconds(1)
        dispatchSourceTimer?.scheduleRepeating(deadline: DispatchTime.now(), interval: interval, leeway: leeway)

        dispatchSourceTimer?.setEventHandler {
            self.block?(self)
        }
        dispatchSourceTimer?.resume()
    }
}
