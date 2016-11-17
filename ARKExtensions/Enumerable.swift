//
//  Enumerable.swift
//  TimeLoggerScandi
//
//  Created by Daniyelian, Arkadzi on 10/2/16.
//  Copyright © 2016 ark.dan. All rights reserved.
//

import Foundation

public protocol Enumerable: RawRepresentable {
    static var first: Self? { get }
    func next() -> Self?
}

extension Enumerable {
    public static var allValues: [Self] {
        guard var value = Self.first else {
            return []
        }

        var all: [Self] = [value]
        while let next = value.next() {
            all.append(next)
            value = next
        }
        return all
    }
}

extension Enumerable where RawValue == Int {

    /// no value on last
    public func next() -> Self? {
        return Self(rawValue: rawValue + 1)
    }

    public static var first: Self? {
        return Self(rawValue: 0)
    }
}
