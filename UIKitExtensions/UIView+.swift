//
//  UIViewExtensions.swift
//  PhotoStory
//
//  Created by mac on 12/8/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import UIKit


extension UIView {

    public func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    public func makeRounded(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    public func makeRounded() {
        let s = min(bounds.width, bounds.height)
        self.makeRounded(radius: s / 2)
    }

    public func applyRoundBorder(radius: CGFloatConvertible, width: CGFloatConvertible, color c: UIColor? = nil) {
        let color = c ?? tintColor
        layer.borderColor = color?.cgColor
        layer.borderWidth = width.cgFloat
        layer.cornerRadius = radius.cgFloat
    }
}

extension UIView {
    public func pin(subview: UIView) {
        constraint(.top, .bottom, .leading, .trailing, subview: subview)
    }
}

extension UIView {
    public class var identifier: String {
        return String(describing: self)
    }
}

extension UIView {
    public func applyShadow(color: UIColor, radius: CGFloat = 5) {
        let apply: (CALayer) -> () = { layer in
            layer.shadowColor = color.cgColor
            layer.shadowOffset = .zero
            layer.shadowOpacity = 1
            layer.shadowRadius = radius
            layer.shouldRasterize = false
        }

        apply(layer)
    }
}
