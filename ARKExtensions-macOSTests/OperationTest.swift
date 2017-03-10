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

    private(set) var executed = false
    let delay: Double

    init(delay: Double) {
        self.delay = delay
        super.init()
    }

    override func execute() {
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

    func testObjectLifeBlockInit() {
        let op1Exp = expectation(description: #function + "op1")
        let op2Exp = expectation(description: #function + "op2")
        let queueExp = expectation(description: #function + "queue")

        var op1: OOperation? = OOperation { finised in
            finised()
        }
        var op2: OOperation? = OOperation { finised in
            finised()
        }
        op1!.completionBlock = {
            print("op1 completion")
            op1Exp.fulfill()
        }
        op2!.completionBlock = {
            print("op2 completion")
            op2Exp.fulfill()
        }

        operationQueue.completionBlock = {
            print("queue completoin")
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

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testObjectLife() {
        let op1Exp = expectation(description: #function + "op1")
        let op2Exp = expectation(description: #function + "op2")
        let queueExp = expectation(description: #function + "queue")

        var op1: OOperation? = OOperation()
        op1?.execution = { finised in
            finised()
        }
        var op2: OOperation? = OOperation()
        op2?.execution = { finised in
            finised()
        }

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

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testCancel() {
        let op1Exp = expectation(description: #function + "op1")
        let queueExp = expectation(description: #function + "queue")

        var op1Executted = false
        var op2Executted = false

        let op2 = OOperation { finised in
            op2Executted = true
            finised()
        }

        let op1 = OOperation { finised in
            op1Executted = true
            op2.cancel()
            finised()
        }

        op2.addDependency(op1)

        op1.completionBlock = {
            op1Exp.fulfill()
        }
        op2.completionBlock = {
        }

        operationQueue.completionBlock = {
            expect(op1Executted) == true
            expect(op2Executted) == false
            queueExp.fulfill()
        }

        operationQueue.maxConcurrentOperationCount = 1

        operationQueue.isSuspended = true
        operationQueue.addOperation(op2)
        operationQueue.addOperation(op1)
        operationQueue.isSuspended = false

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
