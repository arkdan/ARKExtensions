//
//  StringTests.swift
//  ARKExtensions
//
//  Created by ark dan on 2/1/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import Extensions

class StringTests: XCTestCase {

    func testIndexes() {
        let original = "0123456789"

        var substring = original.substring(from: 0)
        expect(substring) == original

        substring = original.substring(to: 10)
        expect(substring) == original

        substring = original.substring(from: 1)
        expect(substring) == "123456789"

        substring = original.substring(to: 9)
        expect(substring) == "012345678"

        substring = original.substring(with: 5..<6)
        expect(substring) == "5"
    }

}
