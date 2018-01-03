//
//  OptionSet+.swift
//  PhotoStory
//
//  Created by mac on 12/19/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation

extension OptionSet where RawValue == Int {

    public init(intValue: RawValue) {
        let rawValue = 1 << intValue
        self.init(rawValue: rawValue)
    }
}
