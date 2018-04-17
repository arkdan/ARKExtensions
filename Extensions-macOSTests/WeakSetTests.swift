//
//  WeakSetTests.swift
//  ARKExtensions
//
//  Created by ark dan on 11/06/2017.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import Extensions

class WeakSetTests: XCTestCase {

    func testAddObject() {
        var a: Listener? = Listener(name: "aaa")
        var b: Listener? = Listener(name: "bbb")
        var c: Listener? = Listener(name: "ccc")

        let weakSet = WeakObjectSet<Listener>()
        expect(weakSet.allObjects) == []

        weakSet.add(a!)
        expect(weakSet.allObjects) == [a!]

        weakSet.add(Listener(name: "aaa"))
        expect(weakSet.allObjects) == [a!]

        weakSet.add(b!)
        expect(weakSet.allObjects.sorted()) == [a!, b!]

        a = nil
        expect(weakSet.allObjects) == [b!]

        weakSet.add(c!)
        expect(weakSet.allObjects.sorted()) == [b!, c!]

        c = nil
        expect(weakSet.allObjects) == [b!]

        b = nil
        expect(weakSet.allObjects) == []
        expect(weakSet.isEmpty) == true
    }

    func testObjectRemove() {
        var a: Listener? = Listener(name: "aaa")
        let b = Listener(name: "bbb")
        let c = Listener(name: "ccc")

        let weakSet = WeakObjectSet<Listener>()
        expect(weakSet.allObjects) == []

        weakSet.add([a!, c, b])
        expect(weakSet.allObjects.sorted()) == [a!, b, c]

        weakSet.remove(b)
        expect(weakSet.allObjects.sorted()) == [a!, c]

        weakSet.remove(c)
        expect(weakSet.allObjects.sorted()) == [a!]

        a = nil
        expect(weakSet.isEmpty) == true
    }

    func testContains() {
        var object: Listener? = Listener(name: "aaa")

        let weakSet = WeakObjectSet<Listener>()

        weakSet.add(object!)
        expect(weakSet.contains(object!)) == true

        let copy = Listener(name: "aaa")
        expect(weakSet.contains(copy)) == false

        var pointer = object
        expect(weakSet.contains(pointer!)) == true

        object = nil
        expect(weakSet.isEmpty) == false

        pointer = nil
        expect(weakSet.isEmpty) == true
    }

    func testCleanup() {
        let a: Listener? = Listener(name: "aaa")
        let b: Listener? = Listener(name: "bbb")
        let c: Listener? = Listener(name: "ccc")
        var d: Listener? = Listener(name: "ddd")
        var e: Listener? = Listener(name: "eee")
        var f: Listener? = Listener(name: "fff")

        let weakSet = WeakObjectSet<Listener>()
        expect(weakSet.allObjects) == []

        weakSet.add(d!)
        weakSet.add(f!)
        weakSet.add(e!)
        weakSet.add(b!)
        weakSet.add(c!)
        weakSet.add(a!)

        weakSet.add(f!)
        weakSet.add(e!)
        weakSet.add(b!)
        weakSet.add(c!)

        expect(weakSet.allObjects.sorted()) == [a!, b!, c!, d!, e!, f!]

        e = nil
        f = nil
        d = nil

        expect(weakSet.allObjects.sorted()) == [a!, b!, c!]
    }
}

final class Listener {
    let name: String
    init(name: String) {
        self.name = name
    }
}

extension Listener: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}
extension Listener: Comparable {
    static func ==(lhs: Listener, rhs: Listener) -> Bool {
        return lhs.name == rhs.name
    }
    static func <(lhs: Listener, rhs: Listener) -> Bool {
        return lhs.name < rhs.name
    }
}
