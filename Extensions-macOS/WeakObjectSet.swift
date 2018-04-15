//
//  WeakObjectSet.swift
//  ARKExtensions
//
//  Created by ark dan on 08/06/2017.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation

final private class WeakObject<T: AnyObject>: Equatable, Hashable where T: Hashable {

    weak var object: T?

    init(_ object: T, _ containingSet: WeakObjectSet<T>? = nil) {
        self.object = object
    }

    var hashValue: Int {
        if let object = self.object {
            return Unmanaged.passUnretained(object).toOpaque().hashValue
        }
        return 0
    }

    static func == (lhs: WeakObject<T>, rhs: WeakObject<T>) -> Bool {
        return lhs.object === rhs.object
    }
}


public final class WeakObjectSet<T: AnyObject> where T: Hashable {

    fileprivate var set: Set<WeakObject<T>>

    public init() {
        self.set = Set<WeakObject<T>>([])
    }

    public init(_ objects: [T]) {
        self.set = Set<WeakObject<T>>(objects.map { WeakObject($0) })
    }

    public init(_ objects: Set<T>) {
        self.set = Set<WeakObject<T>>(objects.map { WeakObject($0) })
    }

    public var allObjects: [T] {
        return set.compactMap { $0.object }
    }

    public var isEmpty: Bool {
        return allObjects.isEmpty
    }

    public func contains(_ object: T) -> Bool {
        return set.contains(WeakObject(object))
    }

    public func add(_ object: T) {

        // reuse WeakObjects already in the set, whose objects have already been deallocated.
        // Otherwise allocate a new WeakObject with object.
        // That makes sense, thanks for clarity.
        if let index = set.index(where: { $0.object == nil }) {
            let weakObject = set[index]
            weakObject.object = object
        } else {
            set.insert(WeakObject(object))
        }
    }

    public func add(_ objects: [T]) {
        objects.forEach { self.add($0) }
    }

    public func remove(_ object: T) {
        set.remove(WeakObject(object))
    }
}
