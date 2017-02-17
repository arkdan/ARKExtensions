//
//  DispatchTimer.swift
//  ARKExtensions
//
//  Created by ark dan on 1/31/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation

public class DispatchTimer {

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
    public var block: ((DispatchTimer) -> Void)?
    private(set) public var fireCount: Int = 0
    private(set) public var maxFireCount: Int

    fileprivate var dispatchSourceTimer: DispatchSourceTimer?


    public init(timeInterval: Double, queue: DispatchQueue, maxCount: Int = .max, block: ((DispatchTimer) -> Void)? = nil) {
        self.timeInterval = timeInterval >= 1e-6 ? timeInterval : 1e-6
        self.queue = queue
        self.maxFireCount = maxCount
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
        dispatchSourceTimer?.scheduleRepeating(deadline: .fromNow(seconds: timeInterval),
                                               interval: .withSeconds(timeInterval),
                                               leeway: .nanoseconds(1))

        let handler: () -> ()
        if maxFireCount == Int.max {
            handler = {
                self.fireCount += 1
                self.block?(self)
            }
        } else {
            handler = {
                guard self.fireCount < self.maxFireCount else {
                    self.cancel()
                    return
                }

                self.fireCount += 1
                self.block?(self)
            }
        }

        dispatchSourceTimer?.setEventHandler(handler: handler)
        dispatchSourceTimer?.resume()
    }
}
