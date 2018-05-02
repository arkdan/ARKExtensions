//
//  UIViewController+.swift
//  UIKitExtensions
//
//  Created by arkadzi.daniyelian on 02/05/2018.
//  Copyright © 2018 arkdan. All rights reserved.
//

import UIKit

extension UIViewController {

    public func topMostViewController() -> UIViewController {
        guard let presented = self.presentedViewController else {
            return self
        }
        if let navigation = presented as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tabBar = presented as? UITabBarController {
            if let selectedTab = tabBar.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tabBar.topMostViewController()
        }

        return presented.topMostViewController()
    }
}

extension UIApplication {
    public func topMostViewController() -> UIViewController? {
        let rootVC = delegate?.window??.rootViewController
        return rootVC?.topMostViewController()
    }

    public func topMostView() -> UIView? {
        guard let vc = topMostViewController() else { return nil }
        let subviews = vc.view.subviews
        return subviews.last ?? vc.view
    }
}
