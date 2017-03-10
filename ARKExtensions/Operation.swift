//
//  Operation.swift
//  ARKExtensions
//
//  Created by ark dan on 1/3/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation

public typealias Execution = (_ finished: @escaping () -> Void) -> Void

open class OOperation: Operation {

    fileprivate var privateCompletionBlock: ((OOperation) -> Void)?

    /// provide either 'execution' block, or override func execute(). The block takes priority.
    open var execution: Execution?

    public init(block: @escaping Execution) {
        super.init()
        execution = block
    }

    public override init() {
        super.init()
    }

    override open var isAsynchronous: Bool {
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

    override open var isExecuting: Bool {
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

    override open var isFinished: Bool {
        return _finished
    }

    override open func start() {
        if isCancelled {
            finish()
            return
        }

        _executing = true
        if let execution = self.execution {
            execution(finish)
        } else {
            execute()
        }
    }

    open func execute() {
        fatalError("Must override execute() or provide 'execution' block")
    }

    open func finish() {
        _executing = false
        _finished = true
        privateCompletionBlock?(self)
    }
    
}

open class OOperationQueue: OperationQueue {

    override init() {
        super.init()
        addObserver(self, forKeyPath: #keyPath(operationCount), options: .new, context: nil)
    }

    open var completionBlock: (() -> Void)?

    // i need a hack here,
    // due to asyncronous nature of operations, i need to know whether i notified interested party about
    // completion.
    private var notifiedHack = false

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("queue count \(operationCount)")
    }

    override open func addOperation(_ operation: Operation) {
        guard let op = operation as? OOperation else {
            fatalError("This class only works with OOperation objects")
        }

        super.addOperation(op)
        notifiedHack = false

        op.privateCompletionBlock = { operation in
            if self.operationCount == 0 && !self.notifiedHack {
                self.notifiedHack = true
                self.completionBlock?()
            }
        }
    }
    
}

