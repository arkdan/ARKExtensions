//
//  TapAction.swift
//  PhotoStory
//
//  Created by mac on 12/8/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import UIKit

private var view = "view"
private var barItem = "barItem"
private var button = "button"

private func setAssociatedObject<T>(_ object: AnyObject, value: T, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
    objc_setAssociatedObject(object, associativeKey, value,  policy)
}

private func getAssociatedObject<T>(_ object: AnyObject, associativeKey: UnsafeRawPointer) -> T? {
    if let v = objc_getAssociatedObject(object, associativeKey) as? T {
        return v
    }

    return nil
}

extension UIButton {

    public var action: ((UIButton) -> Void)? {
        get {
            return getAssociatedObject(self, associativeKey: &button)
        }
        set {
            setAssociatedObject(self,
                                value: newValue,
                                associativeKey: &button,
                                policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            removeTarget(self, action: #selector(fff(_:)), for: .touchUpInside)
            if let _ = newValue {
                addTarget(self, action: #selector(fff(_:)), for: .touchUpInside)
            }
        }
    }

    @objc private func fff(_ sender: UIButton) {
        action?(sender)
    }
}

extension UIBarButtonItem {

    public var tapAction: ((UIBarButtonItem) -> Void)? {
        get {
            return getAssociatedObject(self, associativeKey: &barItem)
        }
        set {
            setAssociatedObject(self,
                                value: newValue,
                                associativeKey: &barItem,
                                policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let _ = newValue {
                target = self
                action = #selector(UIBarButtonItem.fff(_:))
            } else {
                target = nil
                action = nil
            }
        }
    }

    public func sendAction() {
        guard let t = target, let action = action else { return }
        UIApplication.shared.sendAction(action, to: t, from: nil, for: nil)
    }

    @objc private func fff(_ sender: UIBarButtonItem) {
        tapAction?(self)
    }
}
