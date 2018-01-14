//
//  OptionSetTests.swift
//  ARKExtensions
//
//  Created by mac on 12/19/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import Extensions

class OptionSetTests: XCTestCase {

    struct TOptionSet: OptionSet {
        let rawValue: Int

        static let t0 = TOptionSet(intValue: 0)
        static let t1 = TOptionSet(intValue: 1)
        static let t2 = TOptionSet(intValue: 2)
        static let t3 = TOptionSet(intValue: 3)
        static let t4 = TOptionSet(intValue: 4)
        static let t5 = TOptionSet(intValue: 5)
    }

    func testInit() {
        let t0: TOptionSet = .t0
        let t1: TOptionSet = .t1
        let t2: TOptionSet = .t2
        let t3: TOptionSet = .t3
        let t4: TOptionSet = .t4
        let t5: TOptionSet = .t5

        expect(t0.rawValue) == 0b1
        expect(t1.rawValue) == 0b10
        expect(t2.rawValue) == 0b100
        expect(t3.rawValue) == 0b1000
        expect(t4.rawValue) == 0b10000
        expect(t5.rawValue) == 0b100000
    }

}
