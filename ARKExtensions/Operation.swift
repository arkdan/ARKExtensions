//
//  Operation.swift
//  ARKExtensions
//
//  Created by ark dan on 1/3/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation

class OOperation: Operation {

    var execution: ((_ finished: @escaping (Void) -> Void) -> Void)?

    override var isAsynchronous: Bool {
        return true
    }

    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }

    override var isExecuting: Bool {
        return _executing
    }

    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }

    override var isFinished: Bool {
        return _finished
    }

    override func start() {
        guard let execute = self.execution, !isCancelled else {
            finish()
            return
        }

        _executing = true
        execute(finish)
    }

    func finish() {
        _executing = false
        _finished = true
    }

}

