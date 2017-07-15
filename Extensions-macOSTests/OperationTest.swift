//
//  OperationTest.swift
//  ARKExtensions
//
//  Created by ark dan on 2/6/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import Extensions

func currentQueueName() -> String? {
    let name = __dispatch_queue_get_label(nil)
    return String(cString: name, encoding: .utf8)
}

class ExecOperation: OOperation {

    private(set) var executed = false

    private(set) var delay = 0.05

    init(name: String? = nil, delay: Double? = nil) {
        super.init()
        self.name = name
        if let delay = delay {
            self.delay = delay
        }
        self.execution = { finished in
            Extensions.delay(self.delay) {
                self.executed = true
                finished()
            }
        }
    }
}


class OperationTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testCompletion() {

        let operationQueue = OOperationQueue()

        let op1Exp = expectation(description: #function + "op1")
        let op2Exp = expectation(description: #function + "op2")
        let queueExp = expectation(description: #function + "queue")

        let op1 = ExecOperation(name: "op1")
        let op2 = ExecOperation(name: "op2")
        op2.addDependency(op1)

        expect(op2.executed) == false
        expect(op1.executed) == false

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
        operationQueue.whenEmpty = {
            expect(op1.executed) == true
            expect(op2.executed) == true
            queueExp.fulfill()
        }

        operationQueue.maxConcurrentOperationCount = 1

        operationQueue.isSuspended = true
        operationQueue.addOperation(op2)
        operationQueue.addOperation(op1)
        operationQueue.isSuspended = false

        waitForExpectations(timeout: 0.11, handler: nil)
    }

    func testObjectLife() {
        let operationQueue = OOperationQueue()

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

        operationQueue.whenEmpty = {
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

    func testObjectLifeBlockInit() {
        let operationQueue = OOperationQueue()

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
            op1Exp.fulfill()
        }
        op2!.completionBlock = {
            op2Exp.fulfill()
        }

        operationQueue.whenEmpty = {
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

        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testManyTimes() {
        measure {
            self.testObjectLife()
            self.testObjectLifeBlockInit()
        }
    }

}
