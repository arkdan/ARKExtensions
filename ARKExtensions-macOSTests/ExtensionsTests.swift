//
//  ExtensionsTests.swift
//  ARKExtensions
//
//  Created by arkdan on 12/14/16.
//  Copyright © 2016 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import ARKExtensions

class ExtensionsTests: XCTestCase {


    func testDoubleRound() {
        let double = 0.123456789;
        let rounded = double.round(2)
        expect(rounded) == 0.12


        let pi = Double.pi
        let pi3 = pi.round(3)
        expect(pi3) == 3.142

        let pi0 = pi.round(0)
        expect(pi0) == 3

        expect(pi.round(2)) == pi3.round(2)
    }

    func testSafeSubscript() {
        let array = ["0", "1", "2", "3", "4", "5", "6"]
        expect(array[safe: 4]) == "4"
        expect(array[safe: -1]).to(beNil())
        expect(array[safe: 7]).to(beNil())
    }


    func testObjectAddress() {
        let object = NSObject()
        let addressString = NSString(format: "%p", object) as String
        let sss = address(of: object)
        expect(sss) == addressString
    }

}
