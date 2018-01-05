//
//  UIStoryboard+.swift
//  UIKitExtensions
//
//  Created by mac on 1/5/18.
//  Copyright © 2018 arkdan. All rights reserved.
//

import UIKit

extension UIStoryboard {
    @nonobjc public static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
extension UIStoryboard {
    public func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T {
        return instantiateViewController(withIdentifier: type.identifier) as! T
    }
}
