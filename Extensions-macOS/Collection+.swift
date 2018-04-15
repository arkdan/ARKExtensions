//
//  Collection+.swift
//  ARKExtensions
//
//  Created by mac on 12/8/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation

extension Collection {
    public subscript(safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}

extension Collection {
    public func mapArray<E, T>(_ transform: (E) throws -> T) rethrows -> [[T]] where Self.Element == [E] {
        return try map { try $0.map(transform) }
    }
}

extension Collection where Index == Int {
    public func anyItem() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }

    /// exception if collection empty. Use anyItem() to be safe.
    public func any() -> Iterator.Element {
        return self[Int(arc4random_uniform(UInt32(endIndex)))]
    }
}

extension MutableCollection {

    public mutating func shuffle() {
        guard count > 1 else { return }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: count, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {

    public func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension Array {
    public func appending(_ newElement: Element) -> [Element] {
        var copy = self
        copy.append(newElement)
        return copy
    }
}

extension Array {

    public typealias Property<T> = (Element) -> T

    public mutating func sort<T>(property: Property<T>, compare: (T, T) -> Bool) {
        sort { (element1, element2) -> Bool in
            let value1 = property(element1)
            let value2 = property(element2)
            return compare(value1, value2)
        }
    }

    public func sorted<T>(property: Property<T>, compare: (T, T) -> Bool) -> [Element] {
        var copy = self
        copy.sort(property: property, compare: compare)
        return copy
    }

    public mutating func sort<T: Comparable>(property: Property<T>, ascending: Bool = true) {
        sort { (element1, element2) -> Bool in
            let value1 = property(element1)
            let value2 = property(element2)
            if value1 < value2 {
                return ascending
            }
            if value1 > value2 {
                return !ascending
            }
            return true
        }
    }

    public func sorted<T: Comparable>(property: Property<T>, ascending: Bool = true) -> [Element] {
        var copy = self
        copy.sort(property: property, ascending: ascending)
        return copy
    }

}


extension Array {
    public func containsAllElements<S : Sequence>(from other: S) -> Bool where S.Element: Equatable, S.Element == Element {
        for element in other {
            if !contains(element) {
                return false
            }
        }
        return true
    }
}
