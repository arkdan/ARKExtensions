//
//  ConfiguredCell.swift
//  UIKitExtensions
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import Foundation

public protocol ViewModelConfiguredCell {
    associatedtype ViewModelType

    func configure(with: ViewModelType)
    static var identifier: String { get }
}
