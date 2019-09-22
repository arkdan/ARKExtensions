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
    var order: Int?

    init(_ object: T) {
        self.object = object
    }

    var isEmpty: Bool {
        return object == nil
    }

    func hash(into hasher: inout Hasher) {
        let hash: Int
        if let object = self.object {
            hash = Unmanaged.passUnretained(object).toOpaque().hashValue
        } else {
            hash = 0
        }
        hasher.combine(hash)
    }

    static func ==(lhs: WeakBox<T>, rhs: WeakBox<T>) -> Bool {
        return lhs.object === rhs.object
    }
}


public final class WeakObjectSet<T: AnyObject> where T: Hashable {

    private var set: Set<WeakBox<T>>

    private var order = 0

    public init() {
        self.set = Set<WeakBox<T>>([])
    }

    public init(_ objects: [T]) {
        var order = 0
        self.set = Set<WeakBox<T>>(objects.map {
            var box = WeakBox($0)
            box.order = order
            order += 1
            return box
        })
        self.order = order
    }

    public init(_ objects: Set<T>) {
        var order = 0
        self.set = Set<WeakBox<T>>(objects.map {
            var box = WeakBox($0)
            box.order = order
            order += 1
            return box
        })
        self.order = order
    }

    public var allObjects: [T] {
        dropEmpty()
        return set.map { $0.object! }
    }

    public var ordered: [T] {
        dropEmpty()
        return set.sorted { $0.order < $1.order } .map { $0.object! }
    }

    public var isEmpty: Bool {
        return allObjects.isEmpty
    }

    public func contains(_ object: T) -> Bool {
        return set.contains(WeakBox(object))
    }

    public func add(_ object: T) {

        dropEmpty()
        var box = WeakBox(object)
        incrementOrder(with: &box)
        set.insert(box)
    }

    public func add(_ objects: [T]) {

        dropEmpty()

        let add: (T) -> Void = { object in
            var box = WeakBox(object)
            self.incrementOrder(with: &box)
            self.set.insert(box)
        }
        objects.forEach { add($0) }
    }

    public func remove(_ object: T) {
        set.remove(WeakBox(object))
    }

    // Deletes boxes whose objects are released
    private func dropEmpty() {
        var done = false
        repeat {
            if let index = set.firstIndex(where: { $0.isEmpty }) {
                set.remove(at: index)
            } else {
                done = true
            }
        } while done == false
    }

    private func incrementOrder(with object: inout WeakBox<T>) {
        object.order = order
        order += 1
    }
}
