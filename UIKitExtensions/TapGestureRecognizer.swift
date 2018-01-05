//
//  TapGestureRecognizer.swift
//  UIKitExtensions
//
//  Created by mac on 1/5/18.
//  Copyright © 2018 arkdan. All rights reserved.
//

import UIKit

@objc open class TapGestureRecognizer: UITapGestureRecognizer {
    public var action: (TapGestureRecognizer) -> ()
    public init(action: @escaping (TapGestureRecognizer) -> ()) {
        self.action = action
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(onTap(sender:)))
    }

    public convenience init() {
        self.init(action: { _ in })
    }

    @objc private func onTap(sender: TapGestureRecognizer) {
        action(self)
    }
}
