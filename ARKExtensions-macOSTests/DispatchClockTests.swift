//
//  DispatchClockTests.swift
//  ARKExtensions
//
//  Created by ark dan on 1/31/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import ARKExtensions

class DispatchClockTests: XCTestCase {


    var clock: DispatchClock?
    var count = 0

    override func setUp() {
        super.setUp()

    }

    func testTimeInterval() {
        var clock = DispatchClock(timeInterval: -1, queue: DispatchQueue(label: "rrr"))
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

        clock = DispatchClock(timeInterval: 0, queue: DispatchQueue(label: "rrr"))
        expect(clock.timeInterval) == 1e-6
    }

    func testInitWithBlock() {
        let exp = expectation(description: #function)
        let queue = DispatchQueue(label: "xxxxx")
        let ti = 0.1
        let times = 10
        var count = 0
        let _ = DispatchClock(timeInterval: ti, queue: queue) { clock in
            print("1")
            count += 1
            if count == times {
                clock.cancel()
            }
        }

        Timer.ssscheduledTimer(withTimeInterval: ti * Double(times + 5), repeats: false) { (_) in
            expect(count) == times
            exp.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testBlockLater() {
        let exp = expectation(description: #function)
        let queue = DispatchQueue(label: "xxxxx")
        let ti = 0.1
        let times = 10
        var count = 0
        let clock = DispatchClock(timeInterval: ti, queue: queue)
        clock.block = { clock in
            print("2")
            count += 1
            if count == times {
                clock.cancel()
            }
        }

        Timer.ssscheduledTimer(withTimeInterval: ti * Double(times + 5), repeats: false) { (_) in
            expect(count) == times
            exp.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testBlockSwitch() {
        let exp = expectation(description: #function)
        let queue = DispatchQueue(label: "xxxxx")
        let ti = 0.1
        let times = 10
        var count = 0
        let clock = DispatchClock(timeInterval: ti, queue: queue)

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

        Timer.ssscheduledTimer(withTimeInterval: ti * Double(times + 7), repeats: false) { (_) in
            expect(count) == times
            exp.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testNoRetainCycle() {
        let exp = expectation(description: #function)
        let queue = DispatchQueue(label: "xxxxx")
        let ti = 0.1
        let times = 10
        self.clock = DispatchClock(timeInterval: ti, queue: queue)

        self.clock?.block = { clock in
            print("11")
            self.count += 1
            if self.count == 5 {
                clock.block = { clock in
                    print("22")
                    self.count += 1
                    if self.count == times {
                        clock.cancel()
                        self.clock = nil
                    }
                }
            }
        }

        Timer.ssscheduledTimer(withTimeInterval: ti * Double(times + 7), repeats: false) { (_) in
            expect(self.count) == times
            expect(self.clock).to(beNil())
            exp.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

}
