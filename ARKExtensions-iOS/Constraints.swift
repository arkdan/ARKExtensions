//
//  Constraints.swift
//  ARKExtensions
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

    public typealias ViewAttribute = (view: UIView, attribute: NSLayoutAttribute)

    @discardableResult
    public func constraint(_ attribute: NSLayoutAttribute, to sibbling: ViewAttribute, constant: CGFloat = 0) -> NSLayoutConstraint {
        assert(superview === sibbling.view.superview)
        translatesAutoresizingMaskIntoConstraints = false
        sibbling.view.translatesAutoresizingMaskIntoConstraints = false

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
                                   toItem: sibbling.view,
                                   attribute: sibbling.attribute,
                                   multiplier: 1,
                                   constant: off)
        c.isActive = true
        return c
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
