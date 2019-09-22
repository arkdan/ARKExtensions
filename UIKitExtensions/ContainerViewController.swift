//
//  Container.swift
//  UIKitExtensions
//
//  Created by mac on 11/3/16.
//  Copyright © 2016 ark.dan. All rights reserved.
//

import UIKit


open class ContainerViewController: UIViewController {

    @IBOutlet private var containerView: UIView!

    open private(set) var viewControllers: [UIViewController]!
    open private(set) var selectedIndex = 0 {
        didSet {
            assert(0..<viewControllers.count ~= selectedIndex)
        }
    }


    open func setControllers(_ viewControllers: [UIViewController]) {
        assert(self.viewControllers == nil, "you can set it only once")
        self.viewControllers = viewControllers
    }

    open var selectedViewController: UIViewController? {
        return children.last
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        containerView = UIView()
        view.addSubview(containerView)
        view.pin(subview: containerView)

        assert(viewControllers != nil && !viewControllers.isEmpty)

        if children.isEmpty {
            let viewController = viewControllers[selectedIndex]
            viewController.willMove(toParent: self)
            addChild(viewController)
            addView(viewController.view)
            viewController.didMove(toParent: self)
        }
    }

    open func show(at index: Int) {
        assert(0..<viewControllers.count ~= index, "index \(index) out of bounds")
        if selectedIndex == index { return }
        selectedIndex = index

        guard let current = selectedViewController else { return }

        let new = viewControllers[index]

        addChild(new)
        new.willMove(toParent: self)

        transition(from: current, to: new, duration: 0, options: [], animations: {
        }, completion: { completed in

            current.view.removeFromSuperview()
            self.addView(new.view)

            new.didMove(toParent: self)
            current.removeFromParent()
        })
    }

    private func addView(_ view: UIView) {
        containerView.addSubview(view)
        containerView.constraint(.top, .bottom, .leading, .trailing, subview: view)
    }
}

