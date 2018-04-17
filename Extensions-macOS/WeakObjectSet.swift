//
//  WeakObjectSet.swift
//  ARKExtensions
//
//  Created by ark dan on 08/06/2017.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation

private struct WeakBox<T: AnyObject>: Equatable, Hashable where T: Hashable {

    weak var object: T?

    init(_ object: T) {
        self.object = object
    }

    var isEmpty: Bool {
        return object == nil
    }

    var hashValue: Int {
        if let object = self.object {
            return Unmanaged.passUnretained(object).toOpaque().hashValue
        }
        return 0
    }

    static func ==(lhs: WeakBox<T>, rhs: WeakBox<T>) -> Bool {
        return lhs.object === rhs.object
    }
}


public final class WeakObjectSet<T: AnyObject> where T: Hashable {

    fileprivate var set: Set<WeakBox<T>>

    public init() {
        self.set = Set<WeakBox<T>>([])
    }

    public init(_ objects: [T]) {
        self.set = Set<WeakBox<T>>(objects.map { WeakBox($0) })
    }

    public init(_ objects: Set<T>) {
        self.set = Set<WeakBox<T>>(objects.map { WeakBox($0) })
    }

    public var allObjects: [T] {
        trimEmpty()
        return set.map { $0.object! }
    }

    public var isEmpty: Bool {
        return allObjects.isEmpty
    }

    public func contains(_ object: T) -> Bool {
        return set.contains(WeakBox(object))
    }

    public func add(_ object: T) {

        trimEmpty()
        set.insert(WeakBox(object))
    }

    public func add(_ objects: [T]) {
        objects.forEach { self.add($0) }
    }

    public func remove(_ object: T) {
        set.remove(WeakBox(object))
    }

    // Deletes boxes whose objects are released
    private func trimEmpty() {
        var done = false
        repeat {
            if let index = set.index(where: { $0.isEmpty }) {
                set.remove(at: index)
            } else {
                done = true
            }
        } while done == false
    }
}
