//
//  UIViewController+AlertController.swift
//  UIKitExtensions
//
//  Created by ark dan on 3/25/16.
//  Copyright © 2016 arkdan. All rights reserved.
//


import UIKit
import Extensions

private let alertQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
}()

private class AlertOperation: OOperation {

    let alert: UIAlertController
    var presentation: (UIAlertController) -> Void

    init(title: String?, message: String?, cancelButtonTitle: String, otherButtonTitles: [String]?, handler: ((Int) -> Void)?, presentation: @escaping (UIAlertController) -> Void) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.presentation = presentation
        super.init()
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { [weak self] alert in
            handler?(0)
            self?.finish()
        }
        self.alert.addAction(cancelAction)

        if let titles = otherButtonTitles {
            for (index, title) in titles.enumerated() {
                let action = UIAlertAction(title: title, style: .default) { [weak self] (alert) -> Void in
                    handler?(index + 1) // shifted by one because of 'cancel' action
                    self?.finish()
                }
                alert.addAction(action)
            }
        }
    }

    override func execute() {
        onMain {
            self.presentation(self.alert)
        }
    }
}

extension UIViewController {

    /// Presented form window's rootViewController.
    /// Does nothing if no rootViewController
    /// Returns UIAlertController; or nil if no rootViewController
    @discardableResult
    public class func presentAlert(title: String?, message: String?, cancelButtonTitle: String, otherButtonTitles:[String]? = nil, handler:((Int) -> ())? = nil) -> UIAlertController? {

        if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
            return rootVC.presentAlert(title: title, message: message, cancelButtonTitle: cancelButtonTitle,
                                       otherButtonTitles: otherButtonTitles, handler: handler)
        }
        return nil
    }


    /// Presents UIAlertController form the receiver, with supplied parameters (message, cancel title, ...)
    ///
    /// - Parameters:
    ///   - handler: callback when user taps either button (including Cancel).
    /// buttonIndex == 0 corresponds to Cancel; buttonIndex == 1 - first button from otherButtonTitles
    /// - Returns: responsible UIAlertController; or nil if no rootViewController
    @discardableResult
    public func presentAlert(title: String?, message: String?, cancelButtonTitle: String, otherButtonTitles: [String]? = nil, handler: ((Int) -> ())? = nil) -> UIAlertController {

        let presentation: (UIAlertController) -> Void = { [weak self] alert in
            self?.present(alert, animated: true, completion: nil)
        }

        let op = AlertOperation(title: title, message: message, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles, handler: handler, presentation: presentation)

        alertQueue.addOperation(op)
        return op.alert
    }

}
