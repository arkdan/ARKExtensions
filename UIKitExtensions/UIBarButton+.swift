//
//  UIBarButton+.swift
//  UIKitExtensions
//
//  Created by mac on 12/8/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    public convenience init(image: UIImage?, action: @escaping (UIBarButtonItem) -> Void) {
        self.init(image: image, style: .plain, target: nil, action: nil)
        tapAction = action
    }

    public convenience init(title: String?, action: @escaping (UIBarButtonItem) -> Void) {
        self.init(title: title, style: .plain, target: nil, action: nil)
        tapAction = action
    }

    public convenience init(_ barButtonSystemItem: UIBarButtonItem.SystemItem, action: @escaping (UIBarButtonItem) -> Void) {
        self.init(barButtonSystemItem: barButtonSystemItem, target: nil, action: nil)
        tapAction = action
    }
}
