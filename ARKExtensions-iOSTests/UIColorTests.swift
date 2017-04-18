//
//  UIColorTests.swift
//  ARKExtensions
//
//  Created by ark dan on 4/5/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import ARKExtensions

class UIColorTests: XCTestCase {

    func test255() {

        let rUint: UInt = 153
        let gInt = 102
        let bDouble = 51.0
        
        let color = UIColor(red255: rUint, green: gInt, blue: bDouble)
        expect(color) == UIColor.brown
    }

    func testHex() {
        let magentaHex = 0xFF00FF
        expect(UIColor.magenta.hex()) == magentaHex

        let color = UIColor(hex: magentaHex)
        expect(color) == UIColor.magenta
    }

}
