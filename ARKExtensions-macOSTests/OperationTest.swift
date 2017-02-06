//
//  OperationTest.swift
//  ARKExtensions
//
//  Created by ark dan on 2/6/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import ARKExtensions

class DelayOperation: OOperation {

    var started: ((DelayOperation) -> Void)?
    let delay: Double

    private(set) var executed = false

    init(delay: Double) {
        self.delay = delay
        super.init()
    }

    override func execute() {
        started?(self)
        ARKExtensions.delay(delay) {
            self.executed = true
            self.finish()
        }
    }
}

class OperationTest: XCTestCase {

    var operationQueue = OOperationQueue()

    override func setUp() {
        super.setUp()
    }

    func testCompletion() {
        let op1Exp = expectation(description: #function + "op1")
        let op2Exp = expectation(description: #function + "op2")
        let queueExp = expectation(description: #function + "queue")

        let op1 = DelayOperation(delay: 0.5)
        let op2 = DelayOperation(delay: 0.5)
        op2.addDependency(op1)

        op1.completionBlock = { [weak op1, weak op2] in
            expect(op2?.executed) == false
            expect(op1?.executed) == true
            op1Exp.fulfill()
        }
        op2.completionBlock = { [weak op1, weak op2] in
            expect(op1?.executed) == true
            expect(op2?.executed) == true
            op2Exp.fulfill()
        }
        operationQueue.completionBlock = {
            expect(op1.executed) == true
            expect(op2.executed) == true
            queueExp.fulfill()
        }

        operationQueue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        operationQueue.isSuspended = true
        operationQueue.addOperation(op2)
        operationQueue.addOperation(op1)
        operationQueue.isSuspended = false

        waitForExpectations(timeout: 1.1, handler: nil)
    }

    func testObjectLife() {
        let op1Exp = expectation(description: #function + "op1")
        let op2Exp = expectation(description: #function + "op2")
        let queueExp = expectation(description: #function + "queue")

        var op1: DelayOperation? = DelayOperation(delay: 0.5)
        var op2: DelayOperation? = DelayOperation(delay: 0.5)

        op1!.completionBlock = {
            op1Exp.fulfill()
        }
        op2!.completionBlock = {
            op2Exp.fulfill()
        }

        operationQueue.completionBlock = {
            expect(op1).to(beNil())
            expect(op2).to(beNil())
            queueExp.fulfill()
        }

        operationQueue.isSuspended = true
        operationQueue.addOperation(op2!)
        operationQueue.addOperation(op1!)
        operationQueue.isSuspended = false

        op1 = nil
        op2 = nil

        waitForExpectations(timeout: 1.1, handler: nil)
    }
}
