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
        var short = original[0...]
        expect(substring) == original
        expect(String(short)) == original

        substring = original.substring(to: 10)
        short = original[..<10]
        expect(substring) == original
        expect(String(short)) == original

        substring = original.substring(from: 1)
        short = original[1...]
        expect(substring) == "123456789"
        expect(String(short)) == "123456789"

        substring = original.substring(to: 9)
        short = original[..<9]
        expect(substring) == "012345678"
        expect(String(short)) == "012345678"

        substring = original.substring(with: 5..<6)
        short = original[5..<6]
        expect(substring) == "5"
        expect(String(short)) == "5"
    }

    func testValidEmail() {
        var string = ""

        string = string + "qwertyu"
        expect(string.isValidEmail()) == false
        string = string + "@"
        expect(string.isValidEmail()) == false
        string = string + "dfgh"
        expect(string.isValidEmail()) == false
        string = string + "."
        expect(string.isValidEmail()) == false
        string = string + "n"
        expect(string.isValidEmail()) == false
        string = string + "n"
        expect(string.isValidEmail()) == true

        string = "132ghfhgfghf@12313.12321"
        expect(string.isValidEmail()) == false

        string = "132ghfhgfghf@12313.nnn"
        expect(string.isValidEmail()) == true

        string = "132g.hfhgf.ghf@12313.nnn"
        expect(string.isValidEmail()) == true

        string = "132ghfhgfghf@123 13.nnn"
        expect(string.isValidEmail()) == false

        string = "132ghfhgfghf@12313.n nn"
        expect(string.isValidEmail()) == false
    }
}
