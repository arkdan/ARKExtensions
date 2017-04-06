//
//  Misc.swift
//  ARKExtensions
//
//  Created by ark dan on 11/16/16.
//  Copyright © 2016 arkdan. All rights reserved.
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

extension UIViewController {
    public class var identifier: String {
        return String(describing: self)
    }
}

@objc public class TapGestureRecognizer: UITapGestureRecognizer {
    private let action: (TapGestureRecognizer) -> ()
    public init(action: @escaping (TapGestureRecognizer) -> ()) {
        self.action = action
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(onTap(sender:)))
    }

    @objc private func onTap(sender: TapGestureRecognizer) {
        action(self)
    }
}

extension UIPickerView {
    public class var height: CGFloat {
        return 216
    }
}

