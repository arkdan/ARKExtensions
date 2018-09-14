//
//  String+.swift
//  ARKExtensions
//
//  Created by mac on 1/3/18.
//  Copyright © 2018 arkdan. All rights reserved.
//

import Foundation

extension String {
    public var nsRange: NSRange {
        return NSRange(location: 0, length: count)
    }

    public func index(at offset: Int) -> Index {
        return self.index(startIndex, offsetBy: offset)
    }

    public func substring(from: Int) -> String {
        return String(self[from...])
    }

    public func substring(to: Int) -> String {
        return String(self[..<to])
    }

    public func substring(with range: Range<Int>) -> String {
        return String(self[range])
    }

    public subscript(from: CountablePartialRangeFrom<Int>) -> Substring {
        let fromIndex = index(at: from.lowerBound)
        return self[fromIndex...]
    }

    public subscript(to: PartialRangeUpTo<Int>) -> Substring {
        let toIndex = index(at: to.upperBound)
        return self[..<toIndex]
    }

    public subscript(range: Range<Int>) -> Substring {
        let startIndex = index(at: range.lowerBound)
        let endIndex = index(at: range.upperBound)
        return self[startIndex..<endIndex]
    }
}

extension String {

    public func isValidEmail() -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        return isPassingRegex(pattern)
    }

    public func isPassingRegex(_ pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return false }

        return regex.firstMatch(in: self, options: [], range: self.nsRange) != nil
    }
}

extension String {
    public func trimming(_ string: String) -> String {
        return replacingOccurrences(of: string, with: "")
    }
}

