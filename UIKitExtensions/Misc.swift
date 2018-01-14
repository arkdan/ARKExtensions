//
//  Misc.swift
//  UIKitExtensions
//
//  Created by ark dan on 11/16/16.
//  Copyright © 2016 arkdan. All rights reserved.
//

import UIKit

extension UIViewController {
    public class var identifier: String {
        return String(describing: self)
    }
}

extension UIPickerView {
    public class var height: CGFloat {
        return 216
    }
}

