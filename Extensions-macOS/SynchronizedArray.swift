//
//  SynchronizedArray.swift
//  ARKExtensions
//
//  Created by mac on 4/28/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation

public class SynchronizedArray<T> : ExpressibleByArrayLiteral {
    fileprivate var _array: [T]
    fileprivate var _accessQueue = DispatchQueue(label: "SynchronizedArrayAccess")

    public var elements: [T] {
        return _array
    }
    public var count: Int {
        return _array.count
    }

    public init() {
        _array = []
    }

    public required init(arrayLiteral elements: T...) {
        _array = Array(elements)
    }


    public func append(_ newElement: T) {
        _accessQueue.sync {
            self._array.append(newElement)
        }
    }
    public func removeAll() {
        _accessQueue.sync {
            self._array.removeAll()
        }
    }
    public subscript(_ index: Int) -> T {
        set {
            _accessQueue.sync {
                self._array[index] = newValue
            }
        }
        get {
            var element: T!
            _accessQueue.sync {
                element = self._array[index]
            }
            return element
        }
    }
}

extension SynchronizedArray : Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var nextIndex = 0
        return AnyIterator {
            defer {
                nextIndex += 1
            }
            return nextIndex == self._array.count ? nil : self._array[nextIndex]
        }
    }
}
