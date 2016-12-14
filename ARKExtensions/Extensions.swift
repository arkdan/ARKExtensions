//
//  Extensions.swift
//  TimeLoggerScandi
//
//  Created by ark dan on 10/4/16.
//  Copyright © 2016 ark.dan. All rights reserved.
//

import Foundation


public func onMain(_ closure: @escaping (() -> ())) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async(execute: {
            closure()
        })
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




extension Collection {
    public subscript(safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}


extension String {
    public var nsRange: NSRange {
        return NSRange(location: 0, length: characters.count)
    }

    public func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    public func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }

    public func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }

    public func substring(with range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
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
    func round(_ digits: Int) -> Double {
        let divisor = pow(10.0, Double(digits))
        return Darwin.round(self * divisor) / divisor
    }
}
