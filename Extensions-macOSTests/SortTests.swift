//
//  SortTests.swift
//  ARKExtensions
//
//  Created by mac on 11/27/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import Extensions


class SortTests: XCTestCase {
    
    func testComparable() {

        let shuffled = (0..<10).shuffled().map { Model(id: "\($0)") }

        let sortedAsc = shuffled.sorted(property: { $0.id })
        let realAsc = (0..<10).map { Model(id: "\($0)") }
        expect(sortedAsc) == realAsc

        let sortedDesc = shuffled.sorted(property: { $0.id }, ascending: false)
        let desc = (0..<10).reversed().map { Model(id: "\($0)") }
        expect(sortedDesc) == desc
    }

    func testComparableMutating() {
        var arr = (0..<10).shuffled().map { Model(id: "\($0)") }

        arr.sort(property: { $0.id })
        let asc = (0..<10).map { Model(id: "\($0)") }
        expect(arr) == asc

        arr = (0..<10).shuffled().map { Model(id: "\($0)") }
        arr.sort(property: { $0.id }, ascending: false)
        let desc = (0..<10).reversed().map { Model(id: "\($0)") }
        expect(arr) == desc
    }

    func testNonComparable() {
        let arr = (0..<10).shuffled().map { _ in Aaaa() }

        let sortedAsc = arr.sorted(property: { $0.xxx }) { $0.i < $1.i }
        var index = 1
        repeat {

            let previous = sortedAsc[index - 1]
            let current = sortedAsc[index]
            expect(previous.xxx.i) < current.xxx.i
            index += 1
        } while index < sortedAsc.count

        let sortedDesc = arr.sorted(property: { $0.xxx }) { $0.i > $1.i }
        index = 1
        repeat {

            let previous = sortedDesc[index - 1]
            let current = sortedDesc[index]
            expect(previous.xxx.i) > current.xxx.i
            index += 1
        } while index < sortedDesc.count
    }
}

struct Model: Equatable {
    let id: String

    static func ==(lhs: Model, rhs: Model) -> Bool {
        return lhs.id == rhs.id
    }
}

class Xxxx {
    var i: Int
    init(i: Int) {
        self.i = i
    }
    class func make() -> Xxxx {
        return Xxxx(i: 100000.random())
    }
}

class Aaaa {
    var xxx: Xxxx = Xxxx.make()
    init() {}
    init(xxx: Xxxx) {
        self.xxx = xxx
    }
}
