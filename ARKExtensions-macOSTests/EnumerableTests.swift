//
//  ARKExtensions_macOSTests.swift
//  ARKExtensions-macOSTests
//
//  Created by Daniyelian, Arkadzi on 12/4/16.
//  Copyright © 2016 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import ARKExtensions

enum Eeee: Int {
    case one
    case two
    case three
    case four
}

enum Wwww {
    case w(Int)
    static let range = 0..<10
}

extension Wwww: Enumerable {
    static var first: Wwww? {
        return w(range.lowerBound)
    }
    func next() -> Wwww? {
        switch self {
        case .w(let index):
            if index == Wwww.range.upperBound - 1 {
                return nil
            }
            return .w(index + 1)
        }
    }
}

extension Eeee: Enumerable {}

class EnumerableTests: XCTestCase {

    func testAllValues() {
        expect(Eeee.allValues) == [.one, .two, .three, .four]
    }

    func testWwww() {
        let all = Wwww.allValues
        expect(all.count) == Wwww.range.count
        for i in Wwww.range {
            let w = all[i]
            switch w {
            case .w(let index):
                expect(index) == i
            }
        }
    }
    
}
