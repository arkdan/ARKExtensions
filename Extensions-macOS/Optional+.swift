//
//  Optional+.swift
//  ARKExtensions
//
//  Created by arkadzi.daniyelian on 18/04/2018.
//  Copyright © 2018 arkdan. All rights reserved.
//

import Foundation

extension Optional: Comparable where Wrapped: Comparable {
    public static func < (lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
        switch (lhs, rhs) {
        case (.some(let lw), .some(let rw)):
            return lw < rw
        case (.some, .none):
            return true
        case (.none, .some):
            return false
        case (.none, .none):
            return true
        }
    }
}
