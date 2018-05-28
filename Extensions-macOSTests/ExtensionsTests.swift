//
//  ExtensionsTests.swift
//  ARKExtensions
//
//  Created by arkdan on 12/14/16.
//  Copyright © 2016 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import Extensions

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

    func testRandom() {

        var count = 2
        var expected: Set<Int> = Set([0, 1])
        var values = Set<Int>()

        for _ in 0..<100 {
            let randomValue = count.random() // 2.random()
            values.insert(randomValue)
        }
        expect(values) == expected

        count = 5
        expected = Set([0, 1, 2, 3, 4])
        values = Set<Int>()

        for _ in 0..<100 {
            let randomValue = count.random() // 5.random()
            values.insert(randomValue)
        }
        expect(values) == expected

        count = 1
        expected = Set([0])
        values = Set<Int>()

        for _ in 0..<100 {
            let randomValue = count.random() // 1.random()
            values.insert(randomValue)
        }
        expect(values) == expected

        count = 0
        expected = Set([0])
        values = Set<Int>()

        for _ in 0..<100 {
            let randomValue = count.random() // 0.random()
            values.insert(randomValue)
        }
        expect(values) == expected
    }

    func testArrayContains() {
        let array = ["f", "x", "m", "f", "a", "c", "n", "k", "r", "r", "f", "f"]

        var contained = ["x", "m", "f", "a", "m"]
        expect(array.containsAllElements(from: contained)) == true

        contained = ["f", "x", "m", "f", "a", "c", "n", "k", "r", "r", "f", "f"].reversed()
        expect(array.containsAllElements(from: contained)) == true

        contained.append(contentsOf: contained)
        expect(array.containsAllElements(from: contained)) == true

        contained = []
        expect(array.containsAllElements(from: contained)) == true

        let notContained = ["x", "m", "f", "a", "m", "5"]
        expect(array.containsAllElements(from: notContained)) == false
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

    func testCollectionAny() {
        var collection = [1, 2, 3, 4, 5, 6, 7]
        let some = collection.any()
        expect(collection.contains(some)) == true

        collection = []
        let other = collection.anyItem()
        expect(other).to(beNil())
    }

}

class NSMutableArrayPerformance: XCTestCase {
    var array = NSMutableArray()

    override func setUp() {
        super.setUp()
        for i in 0..<10_000_000 {
            array.add(NSNumber(value: i))
        }
    }

    func testMiddle() {
        measure {
            self.array.removeObject(at: 500_000)
        }
    }

    func testTop() {
        measure {
            self.array.removeObject(at: 999_000)
        }
    }

    func testBottom() {
        measure {
            self.array.removeObject(at: 1)
        }
    }
}

class SwiftArrayPerformance: XCTestCase {
    var array = [NSNumber]()

    override func setUp() {
        super.setUp()
        for i in 0..<10_000_000 {
            array.append(NSNumber(value: i))
        }
    }

    func testMiddle() {
        measure {
            self.array.remove(at: 500_000)
        }
    }

    func testTop() {
        measure {
            self.array.remove(at: 999_000)
        }
    }

    func testBottom() {
        measure {
            self.array.remove(at: 1)
        }
    }
}

