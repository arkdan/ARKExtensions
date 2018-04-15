//
//  ConstraintsTests.swift
//  ConstraintsTests
//
//  Created by ark dan on 2/18/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import XCTest
import Nimble
@testable import UIKitExtensions


extension CGSize {
    func translated(by value: CGFloatConvertible) -> CGSize {
        let v = value.cgFloat
        return CGSize(width: width + v, height: height + v)
    }
    mutating func translate(by value: CGFloatConvertible) {
        self = translated(by: value)
    }
}

class ConstraintsTests: XCTestCase {

    var vc: UIViewController!
    let vcSize = CGSize(width: 500, height: 500)

    var superview: UIView {
        return vc.view
    }

    override func setUp() {
        super.setUp()
        vc = UIViewController()
        vc.view.bounds.size = vcSize
    }


    func test4Edges() {
        expect(self.superview.bounds.size) == vcSize

        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        expect(subview.bounds.size) == CGSize(width: 100, height: 100)

        superview.addSubview(subview)

        let edgeOffset = 20.cgFloat
        superview.constraint(.top, .bottom, .leading, .trailing, subview: subview, edgeOffset)
        superview.layoutSubviews()
        expect(subview.frame.origin) == CGPoint(x: edgeOffset, y: edgeOffset)
        expect(subview.frame.maxX) == superview.bounds.maxX - edgeOffset
        expect(subview.frame.maxY) == superview.bounds.maxY - edgeOffset
    }

    func testSizeAndCenter() {
        let side = 100.cgFloat
        let innerSize = CGSize(width: side, height: side)
        let subview = UIView(frame: .zero)
        subview.frame.size = innerSize
        expect(subview.bounds.size) == innerSize

        superview.addSubview(subview)

        let smallerBy = (vcSize.width - innerSize.width) / 2

        superview.constraint(.centerX, .centerY, subview: subview)
        subview.constraint(.width, side)
        subview.constraint(.height, side)
        superview.layoutSubviews()
        expect(subview.frame.origin) == CGPoint(x: smallerBy, y: smallerBy)
        expect(subview.frame.maxX) == superview.bounds.maxX - smallerBy.cgFloat
        expect(subview.frame.maxY) == superview.bounds.maxY - smallerBy.cgFloat
    }

    func testCenterOffset() {
        let inner = UIView(frame: .zero)

        superview.addSubview(inner)

        let centerOffset = 10.cgFloat

        superview.constraint(.centerX, .centerY, subview: inner, -centerOffset)

        inner.constraint(.width, vcSize.width)
        inner.constraint(.height, vcSize.height)
        superview.layoutSubviews()

        expect(inner.frame.maxX) == superview.bounds.maxX - centerOffset
        expect(inner.frame.maxY) == superview.bounds.maxY - centerOffset
        expect(inner.frame.minX) == superview.bounds.minX - centerOffset
        expect(inner.frame.minY) == superview.bounds.minY - centerOffset
    }

    func testSibblings() {
        let subview1 = UIView(frame: .zero)
        let subview2 = UIView(frame: .zero)

        superview.addSubview(subview1)
        superview.addSubview(subview2)


        subview1.constraint(.width, 100)
        subview1.constraint(.height, 100)
        superview.constraint(.leading, .top, subview: subview1, 50)

        subview2.constraint(size: (20, 20))

        // sibblings
        subview2.constraint(.top, to: .top, ofSibling: subview1)
        subview1.constraint(.trailing, to: .leading, ofSibling: subview2, constant: 20)

        superview.layoutSubviews()

        expect(subview1.frame) == CGRect(x: 50, y: 50, width: 100, height: 100)
        expect(subview2.frame) == CGRect(x: 50 + 100 + 20, y: 50, width: 20, height: 20)
    }

    func testPinSibblings() {
        let subview1 = UIView(frame: .zero)
        let subview2 = UIView(frame: .zero)

        superview.addSubview(subview1)
        superview.addSubview(subview2)


        subview1.constraint(.width, 100)
        subview1.constraint(.height, 100)
        superview.constraint(.leading, .top, subview: subview1, 50)

        subview2.pin(toSibling: subview1, 10)

        superview.layoutSubviews()

        let expS1Frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        var expS2Frame = expS1Frame
        expS2Frame.origin.x -= 10
        expS2Frame.origin.y -= 10
        expS2Frame.size.width += 20
        expS2Frame.size.height += 20

        expect(subview1.frame) == expS1Frame
        expect(subview2.frame) == expS2Frame
    }

    func testAssociatedConstraints() {
        let subview1 = UIView(frame: .zero)
        let subview2 = UIView(frame: .zero)

        superview.addSubview(subview1)
        superview.addSubview(subview2)

        var constraints1 = [NSLayoutConstraint]()
        var constraints2 = [NSLayoutConstraint]()

        constraints1.append(subview1.constraint(.width, 100))
        constraints1.append(subview1.constraint(.height, 100))

        constraints2.append(subview2.constraint(.width, 20))
        constraints2.append(subview2.constraint(.height, 20))

        constraints1.append(contentsOf: superview.constraint(.leading, .top, subview: subview1, 50))

        var ttt = subview2.constraint(.top, to: .top, ofSibling: subview1)
        constraints1.append(ttt)
        constraints2.append(ttt)

        ttt = subview1.constraint(.trailing, to: .leading, ofSibling: subview2, constant: 20)
        constraints1.append(ttt)
        constraints2.append(ttt)

        superview.layoutSubviews()
        expect(subview1.frame) == CGRect(x: 50, y: 50, width: 100, height: 100)
        expect(subview2.frame) == CGRect(x: 50 + 100 + 20, y: 50, width: 20, height: 20)

        expect(subview1.associatedConstraints()) == constraints1
        expect(subview2.associatedConstraints()) == constraints2

        subview1.clearConstraints()
        subview2.clearConstraints()

        expect(subview1.associatedConstraints()) == []
        expect(subview2.associatedConstraints()) == []
    }

}
