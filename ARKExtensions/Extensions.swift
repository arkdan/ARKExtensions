//
//  Extensions.swift
//  TimeLoggerScandi
//
//  Created by ark dan on 10/4/16.
//  Copyright © 2016 arkdan. All rights reserved.
//

import Foundation


public func onMain(_ closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async {
            closure()
        }
    }
}

extension DispatchTimeInterval {
    public static func withSeconds(_ seconds: Double) -> DispatchTimeInterval {
        return DispatchTimeInterval.nanoseconds(Int(seconds * 1e9))
    }
}

extension DispatchTime {
    static public func fromNow(seconds: Double) -> DispatchTime {
        return DispatchTime.now() + DispatchTimeInterval.withSeconds(seconds)
    }
}

public func delay(_ time: Double, queue: DispatchQueue = DispatchQueue.main, block: @escaping () -> ()) {
    queue.asyncAfter(deadline: DispatchTime.fromNow(seconds: time), execute: block)
}

extension DispatchQueue {
    public func delayed(_ time: Double, block: @escaping () -> ()) {
        asyncAfter(deadline: DispatchTime.fromNow(seconds: time), execute: block)
    }
}




extension Collection {
    public subscript(safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}


extension String {
    public var nsRange: NSRange {
        return NSRange(location: 0, length: characters.count)
    }

    public func index(at offset: Int) -> Index {
        return self.index(startIndex, offsetBy: offset)
    }

    public func substring(from: Int) -> String {
        let fromIndex = index(at: from)
        return substring(from: fromIndex)
    }

    public func substring(to: Int) -> String {
        let toIndex = index(at: to)
        return substring(to: toIndex)
    }

    public func substring(with range: Range<Int>) -> String {
        let startIndex = index(at: range.lowerBound)
        let endIndex = index(at: range.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}



extension FileManager {
    public func clearDirectory(_ path: String) {
        var isDirectory: ObjCBool = false
        if !fileExists(atPath: path, isDirectory: &isDirectory) {
            fatalError()
        }
        if !isDirectory.boolValue {
            fatalError()
        }

        let paths: [String]
        do {
            paths = try contentsOfDirectory(atPath: path)
        } catch {
            print("\(#function) error: \((error as NSError).localizedDescription)")
            return
        }
        for p in paths {
            try? removeItem(atPath: path + "/" + p)
        }
    }
}


extension Double {
    public func round(_ digits: UInt) -> Double {
        let divisor = pow(10.0, Double(digits))
        return Darwin.round(self * divisor) / divisor
    }
}

/// I mostly use iside print(), so returning String instead of Int
public func address(of object: AnyObject) -> String {
    return "0x" + String(unsafeBitCast(object, to: Int.self), radix: 16)
}

extension Collection where IndexDistance == Int, Index == Int {

    /// Exception if array is empty
    public func randomItem() -> Iterator.Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}
