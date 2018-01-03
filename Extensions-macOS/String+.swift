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
