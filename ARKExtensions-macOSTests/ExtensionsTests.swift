//
//  ExtensionsTests.swift
//  ARKExtensions
//
//  Created by Daniyelian, Arkadzi on 12/14/16.
//  Copyright © 2016 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import ARKExtensions

class ExtensionsTests: XCTestCase {


    func testDoubleRound() {
        let pi = Double.pi
        let pi3 = pi.round(3)
        expect(pi3) == 3.142

        let pi0 = pi.round(0)
        expect(pi0) == 3

        expect(pi.round(2)) == pi3.round(2)
    }

}
