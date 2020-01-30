//
//  PropertyTests.swift
//  ARKExtensions
//
//  Created by mac on 1/31/20.
//  Copyright © 2020 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import Extensions

private class TestObserver {

}

class PropertyTests: XCTestCase {

    func testActionIsCalled() {
        let exp = expectation(description: #function)
        exp.expectedFulfillmentCount = 3

        let property = Property(9)
        property.observeAndFire { value in
            exp.fulfill()
        }

        property.value = 1
        property.value = 2
        waitForExpectations(timeout: 0.2, handler: nil)
    }

    func testActionIsCalledWithObserver() {
        let exp = expectation(description: #function)
        exp.expectedFulfillmentCount = 3

        let property = Property(9)
        let actionId: ActionId? = ActionId()
        property.observe(id: actionId!) { value in
            exp.fulfill()
        }

        property.value = 1
        property.value = 2
        property.value = 3
        waitForExpectations(timeout: 0.2, handler: nil)
    }

    func testActionNotCalledAfterObserverDeallocated() {
        let exp = expectation(description: #function)
        exp.isInverted = true

        let property = Property(9)
        var actionId: ActionId? = ActionId()
        property.observe(id: actionId!) { value in
            exp.fulfill()
        }

        actionId = nil
        property.value = -100
        waitForExpectations(timeout: 0.2, handler: nil)
    }
}
