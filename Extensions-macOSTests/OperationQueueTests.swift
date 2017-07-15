//
//  OperationQueueTests.swift
//  ARKExtensions
//
//  Created by ark dan on 3/18/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import Extensions

class OperationQueueTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }


    func operationsTree() -> [ExecOperation] {
        var all: [ExecOperation] = ["a1", "a1", "a1", "a2", "a3",
                                    "b1", "b2", "b4",
                                    "c5", "c6"].map { ExecOperation(name: $0) }
        // [operation: [operations that depend on it]]
        let relations: [Int: [Int]] = [3: [2],
                                       4: [0, 1, 3],
                                       6: [0],
                                       7: [5, 6],
                                       8: [7],
                                       9: [8]]
        for (op, dependencies) in relations {
            for dependency in dependencies {
                all[op].addDependency(all[dependency])
            }
        }
        return all
    }

    func testEmptyCalledOnce() {

        let exp = expectation(description: #function)
        let emptyExpxp = expectation(description: #function + "empty")

        let ops = operationsTree()

        var execCount = 0
        let time = ops.reduce(0.0) { $0 + $1.delay } + 0.2
        let queue = OOperationQueue()
        queue.isSuspended = true
        for op in ops {
            queue.addOperation(op)
        }
        queue.isSuspended = false

        queue.whenEmpty = {
            execCount += 1
            emptyExpxp.fulfill()
        }

        delay(time) {
            expect(execCount) == 1
            for op in ops {
                if !op.executed {
                    print("**** " + op.name!)
                }
                expect(op.executed) == true
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: time, handler: nil)
    }

    func testCancel() {

        let queue = OOperationQueue()

        let op1Exp = expectation(description: #function + "op1")
        let queueExp = expectation(description: #function + "queue")

        var op1Executed = false
        var op2Executed = false

        let op2 = OOperation { finised in
            op2Executed = true
            finised()
        }

        let op1 = OOperation { finised in
            op1Executed = true
            op2.cancel()
            finised()
        }

        op2.addDependency(op1)

        op1.completionBlock = {
            op1Exp.fulfill()
        }
        op2.completionBlock = {
        }

        queue.whenEmpty = {
            expect(op1Executed) == true
            expect(op2Executed) == false
            queueExp.fulfill()
        }

        queue.maxConcurrentOperationCount = 1

        queue.isSuspended = true
        queue.addOperation(op2)
        queue.addOperation(op1)
        queue.isSuspended = false

        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testManyTimes() {
        measure {
            self.testEmptyCalledOnce()
            self.testCancel()
        }
    }
}
