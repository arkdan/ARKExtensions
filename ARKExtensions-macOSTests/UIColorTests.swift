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
        expect(CGFloat(127.5) / 255) == CGFloat(0.5)

        var color = UIColor(red255: 127.5, green: 127.5, blue: 127.5)
        expect(color) == UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)

        color = UIColor(red255: 127.5, green: 127.5, blue: 127.5, alpha: 0.5)
        expect(color) == UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    }

    func testHex() {
        let magentaHex = 0xFF00FF
        expect(UIColor.magenta.hex()) == magentaHex

        let color = UIColor(hex: magentaHex)
        expect(color) == UIColor.magenta
    }

}
