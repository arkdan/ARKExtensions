//
//  Property.swift
//  ARKExtensions
//
//  Created by mac on 1/31/20.
//  Copyright © 2020 arkdan. All rights reserved.
//

import Foundation

final public class ActionId {
    fileprivate weak var ref: ActionId?
    fileprivate var queue: DispatchQueue?
    fileprivate var onDeinit: (() -> Void)?
    public init() {
    }
    deinit {
        onDeinit?()
    }
}

final public class Property<T> {

    private var observers: [ActionId] = []
    private var actions: [(T) -> Void] = []

    public var value: T {
        didSet {
            onMain {
                for (index, action) in self.actions.enumerated() {
                    if let queue = self.observers[index].queue {
                        queue.async {
                            action(self.value)
                        }
                    } else {
                        action(self.value)
                    }
                }
            }
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    public func observe(id: ActionId? = nil, on queue: DispatchQueue? = nil, action: @escaping (T) -> Void) {
        let actionId = ActionId()
        if let id = id {
            actionId.ref = id
            id.onDeinit = { [weak self] in
                self?.unbind(id: actionId)
            }
        }
        actionId.queue = queue
        observers.append(actionId)
        actions.append(action)
    }

    public func observeAndFire(id: ActionId? = nil, on queue: DispatchQueue = .main, action: @escaping (T) -> Void) {
        observe(id: id, on: queue, action: action)
        action(value)
    }

    public func unbind(id: ActionId) {
        guard let index = observers.firstIndex(where: { $0 === id || $0.ref === id }) else {
            assertionFailure("actionId not found")
            return
        }
        _ = actions.remove(at: index)
        observers.remove(at: index)
    }
}
