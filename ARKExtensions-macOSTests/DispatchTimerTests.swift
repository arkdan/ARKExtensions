//
//  DispatchTimerTests.swift
//  ARKExtensions
//
//  Created by ark dan on 1/31/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import ARKExtensions

class DispatchTimerTests: XCTestCase {

    let queue = DispatchQueue(label: "xxxxx")

    override func setUp() {
        super.setUp()
    }

    func testTimeInterval() {
        var clock = DispatchTimer(timeInterval: -1, queue: DispatchQueue(label: "rrr"))
        expect(clock.timeInterval) == 1e-6

        clock.timeInterval = -3
        expect(clock.timeInterval) == 1e-6

        clock.timeInterval = 0
        expect(clock.timeInterval) == 1e-6

        clock.timeInterval = 1e-6
        expect(clock.timeInterval) == 1e-6

        clock.timeInterval = 1e-5
        expect(clock.timeInterval) == 1e-5

        clock.timeInterval = 0.5
        expect(clock.timeInterval) == 0.5

        clock = DispatchTimer(timeInterval: 0, queue: DispatchQueue(label: "rrr"))
        expect(clock.timeInterval) == 1e-6
    }

    func testInitWithBlock() {
        let exp = expectation(description: #function)
        let ti = 0.1
        let times = 10
        var count = 0
        let _ = DispatchTimer(timeInterval: ti, queue: queue) { clock in
            print("1")
            count += 1
            if count == times {
                clock.cancel()
            }
        }

        let time = ti * Double(times + 5)
        delay(time) {
            expect(count) == times
            exp.fulfill()
        }

        waitForExpectations(timeout: time + 0.01, handler: nil)
    }

    func testBlockLater() {
        let exp = expectation(description: #function)
        let ti = 0.1
        let times = 10
        var count = 0
        let clock = DispatchTimer(timeInterval: ti, queue: queue)
        clock.block = { clock in
            print("2")
            count += 1
            if count == times {
                clock.cancel()
            }
        }

        let time = ti * Double(times + 5)
        delay(time) {
            expect(count) == times
            exp.fulfill()
        }

        waitForExpectations(timeout: time + 0.01, handler: nil)
    }

    func testBlockSwitch() {
        let exp = expectation(description: #function)
        let ti = 0.1
        let times = 10
        var count = 0
        let clock = DispatchTimer(timeInterval: ti, queue: queue)

        clock.block = { clock in
            print("11")
            count += 1
            if count == 5 {
                clock.block = { clock in
                    print("22")
                    count += 1
                    if count == times {
                        clock.cancel()
                    }
                }
            }
        }

        let time = ti * Double(times + 7)
        delay(time) {
            expect(count) == times
            exp.fulfill()
        }

        waitForExpectations(timeout: time + 0.01, handler: nil)
    }

    var clock: DispatchTimer?

    func testNoRetainCycle() {
        let exp = expectation(description: #function)
        let ti = 0.1
        let times = 10
        self.clock = DispatchTimer(timeInterval: ti, queue: queue)

        var count = 0

        self.clock?.block = { clock in
            print("11")
            count += 1
            if count == 5 {
                clock.block = { clock in
                    print("22")
                    count += 1
                    if count == times {
                        clock.cancel()
                        self.clock = nil
                    }
                }
            }
        }

        let time = ti * Double(times + 7)
        delay(time) {
            expect(count) == times
            expect(self.clock).to(beNil())
            exp.fulfill()
        }

        waitForExpectations(timeout: time + 0.01, handler: nil)
    }

    func testFireCount() {
        let exp = expectation(description: #function)

        let interval = 0.01
        var count = 0

        let block: (DispatchTimer) -> () = { clock in
            count += 1
            expect(clock.fireCount) == count
        }

        let max = 100
        let clock = DispatchTimer(timeInterval: interval, queue: queue, maxCount: max, block: block)
        let time = interval * Double(max) + interval * 5
        delay(time) {
            expect(clock.fireCount) == max
            exp.fulfill()
        }

        waitForExpectations(timeout: time + 0.01, handler: nil)
    }

    func testFireCountZero() {
        let exp = expectation(description: #function)

        let interval = 0.01
        var count = 0

        let block: (DispatchTimer) -> () = { clock in
            count += 1
            expect(clock.fireCount) == count
        }

        let max = 0
        let clock = DispatchTimer(timeInterval: interval, queue: queue, maxCount: max, block: block)
        let time = interval * Double(max) + interval * 5
        delay(time) {
            expect(clock.fireCount) == max
            expect(count) == max
            exp.fulfill()
        }

        waitForExpectations(timeout: time + 0.01, handler: nil)
    }

}
