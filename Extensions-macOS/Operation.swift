//
//  Operation.swift
//  ARKExtensions
//
//  Created by ark dan on 1/3/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation


/// OOperations are asynchronous.
open class OOperation: Operation {

    public typealias Execution = (_ finished: @escaping () -> Void) -> Void

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

    /// always true. These thigs are asynchronous.
    override public final var isAsynchronous: Bool {
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

    override public final var isExecuting: Bool {
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

    override public final var isFinished: Bool {
        return _finished
    }

    override public final func start() {
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

    public final func finish() {
        _executing = false
        _finished = true
        privateCompletionBlock?(self)
    }

}

open class OOperationQueue: OperationQueue {

    // need a alternative operations count, because Operation.operationCount is sometimes carries
    // irrelevant values due to concurrent nature of the queue.
    private var ccount = 0


    /// called each time all operations are completed.
    public var whenEmpty: (() -> Void)?

    public convenience init(maxConcurrent: Int) {
        self.init()
        maxConcurrentOperationCount = maxConcurrent
    }

    /*
    override init() {
        super.init()
        addObserver(self, forKeyPath: #keyPath(operations), options: [.new, .old], context: nil)
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        guard let kkeyPath = keyPath, kkeyPath == #keyPath(operations) else {
            return
        }
        let old = change![.oldKey] as! [Operation]
        let new = change![.newKey] as! [Operation]
        print("queue count \(operationCount) \(old.count)->\(new.count)")

        if let kkeyPath = keyPath, kkeyPath == #keyPath(operations),
            let cchange = change,
            let old = cchange[.oldKey] as? [Operation], let new = cchange[.newKey] as? [Operation],
            new.count == 0, old.count == 1 {
            self.whenEmpty?()
            print("trigger")
        }
    }
    */


    /// Supports OOperations only
    override open func addOperation(_ operation: Operation) {
        guard let op = operation as? OOperation else {
            fatalError("This class only works with OOperation objects")
        }

        ccount += 1

        super.addOperation(op)

        op.privateCompletionBlock = { [weak self] operation in
            guard let sself = self else {
                return
            }
            sself.ccount -= 1
            if sself.ccount == 0 {
                sself.whenEmpty?()
            }
        }
    }

    public func addExecution(_ execution: @escaping OOperation.Execution) {
        addOperation(OOperation(block: execution))
    }


    /// Not supported.
    ///
    /// Use addExecution instead. I can't report progress on block operation, which is the main goal of this class
    override open func addOperation(_ block: @escaping () -> Void) {
        fatalError("")
    }

    /// Not supported. OOperationQueue is there to report progress on async execution
    override open func addOperations(_ ops: [Operation], waitUntilFinished wait: Bool) {
        fatalError("Not supported. OOperationQueue is there to report progress on async execution")
    }
}

