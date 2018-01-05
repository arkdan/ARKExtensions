//
//  UIImage+.swift
//  UIKitExtensions
//
//  Created by mac on 1/5/18.
//  Copyright © 2018 arkdan. All rights reserved.
//

import UIKit

extension UIImage {

    public func withRoundedCorners(radius: CGFloat) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: size)

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let maskPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: UIRectCorner.allCorners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        maskPath.addClip()
        self.draw(in: rect)
        let modifiedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return modifiedImage
    }

    public func roundedImageWithBorder(radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: size)

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        borderColor.setFill()

        UIBezierPath(ovalIn: rect).fill()
        let intBox = rect.insetBy(dx: borderWidth, dy: borderWidth)
        let int = UIBezierPath(ovalIn: intBox)
        int.addClip()

        draw(in: rect)

        let modifiedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return modifiedImage
    }

    public func scaleDown(to size: CGSize) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return scaledImage
    }

    public static func with(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
