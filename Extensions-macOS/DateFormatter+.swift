//
//  DateFormatter+.swift
//  ARKExtensions
//
//  Created by ark dan on 12/04/2018.
//  Copyright © 2018 arkdan. All rights reserved.
//

import Foundation

extension DateFormatter {

    public convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}
