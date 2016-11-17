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

extension Eeee: Enumerable {}

class EnumerableTests: XCTestCase {

    func testAllValues() {
        expect(Eeee.allValues) == [.one, .two, .three, .four]
    }
    
}
