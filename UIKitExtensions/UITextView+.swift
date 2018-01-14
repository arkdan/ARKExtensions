//
//  UITextView+.swift
//  UIKitExtensions
//
//  Created by mac on 12/8/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import UIKit

extension UITextView {
    public func alignAtBottom() {
        var inset: UIEdgeInsets = .zero
        inset.top = bounds.height - contentSize.height
        contentInset = inset
    }

    public func applyShadow1(color: UIColor?) {
        layer.shadowColor = color?.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 2
    }
}
