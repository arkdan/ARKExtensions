//
//  OptionalTests.swift
//  ARKExtensions
//
//  Created by arkadzi.daniyelian on 18/04/2018.
//  Copyright © 2018 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import Extensions

class OptionalTests: XCTestCase {

    func testComparable() {
        let arr: [Int?] = [9, 8, 7, 6, 5, 4, nil, 2, nil, 0]
        let sorted = arr.sorted { $0 < $1 }

        expect(sorted) == [0, 2, 4, 5, 6, 7, 8, 9, nil, nil]
    }

}
