//
//  Constraints.swift
//  UIKitExtensions
//
//  Created by ark dan on 11/16/16.
//  Copyright © 2016 arkdan. All rights reserved.
//

import UIKit


extension UIView {

    @discardableResult
    public func constraint(_ attributes: NSLayoutAttribute..., subview: UIView, _ constant: CGFloat = 0) -> [NSLayoutConstraint] {

        assert(subview.superview === self)
        subview.translatesAutoresizingMaskIntoConstraints = false

        var added = [NSLayoutConstraint]()

        for attribute in attributes {
            let off: CGFloat
            switch attribute {
            case .top, .leading, .centerX, .centerY, .width, .height:
                off = constant
            case .bottom, .trailing:
                off = -constant
            default:
                fatalError("attribute \(attribute) not supported")
            }

            let c = NSLayoutConstraint(item: subview,
                                       attribute: attribute,
                                       relatedBy: .equal,
                                       toItem: self,
                                       attribute: attribute,
                                       multiplier: 1,
                                       constant: off)
            c.isActive = true
            added.append(c)
        }
        return added
    }

    @discardableResult
    public func constraint(_ attribute: NSLayoutAttribute, _ constant: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        switch attribute {
        case .width, .height:
            break
        default:
            fatalError("pass .width or .height only")
        }
        let c = NSLayoutConstraint(item: self,
                                   attribute: attribute,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1,
                                   constant: constant)
        c.isActive = true
        return c
    }

    @discardableResult
    public func constraint(_ attribute: NSLayoutAttribute, to siblingAttribute: NSLayoutAttribute, ofSibling sibling: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {

        assert(superview === sibling.superview, "siblings must have same superview!")
        translatesAutoresizingMaskIntoConstraints = false
        sibling.translatesAutoresizingMaskIntoConstraints = false

        let off: CGFloat
        switch attribute {
        case .bottom, .trailing, .right:
            off = -constant
        default:
            off = constant
        }

        let c = NSLayoutConstraint(item: self,
                                   attribute: attribute,
                                   relatedBy: .equal,
                                   toItem: sibling,
                                   attribute: siblingAttribute,
                                   multiplier: 1,
                                   constant: off)
        c.isActive = true
        return c
    }
}

extension UIView {

    public var widthConstraint: NSLayoutConstraint? {
        return constraint(forAttribute: .width)
    }

    public var heightConstraint: NSLayoutConstraint? {
        return constraint(forAttribute: .height)
    }

    public func constraint(forAttribute attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        return constraints.first(where: { $0.firstAttribute == attribute })
    }

    @discardableResult
    public func constraint(size: (CGFloatConvertible, CGFloatConvertible)) -> [NSLayoutConstraint] {
        return constraint(size: CGSize(width: size.0.cgFloat, height: size.1.cgFloat))
    }

    @discardableResult
    public func constraint(size: CGSize) -> [NSLayoutConstraint] {
        return [constraint(.width, size.width), constraint(.height, size.height)]
    }
}


extension UIView {
    public func clearConstraints() {
        NSLayoutConstraint.deactivate(associatedConstraints())
    }

    public func associatedConstraints() -> [NSLayoutConstraint] {
        var constraints = self.constraints
        var superview = self.superview
        while let sv = superview {
            for constraint in sv.constraints {
                if constraint.firstItem === self || constraint.secondItem === self {
                    constraints.append(constraint)
                }
            }
            superview = sv.superview
        }
        return constraints
    }
}

extension UIView {
    public func pin(subview: UIView, _ constant: CGFloatConvertible = 0) {
        constraint(.top, .bottom, .leading, .trailing, subview: subview, constant.cgFloat)
    }

    public func pin(toSibling sibling: UIView, _ constant: CGFloatConvertible = 0) {

        constraint(.top, to: .top, ofSibling: sibling, constant: constant.cgFloat)
        constraint(.bottom, to: .bottom, ofSibling: sibling, constant: constant.cgFloat)
        constraint(.leading, to: .leading, ofSibling: sibling, constant: constant.cgFloat)
        constraint(.trailing, to: .trailing, ofSibling: sibling, constant: constant.cgFloat)
    }
}

