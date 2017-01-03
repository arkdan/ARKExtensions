//
//  UIViewController+AlertController.swift
//  ARKExtensions
//
//  Created by ark dan on 3/25/16.
//  Copyright © 2016 arkdan. All rights reserved.
//


import UIKit


private let alertQueue: OperationQueue = {
    let queue = OperationQueue.main
    queue.maxConcurrentOperationCount = 1
    return queue
}()

extension UIViewController {
    public class func presentAlerttt(title: String?, message: String?, cancelButtonTitle: String, otherButtonTitles:[String]? = nil, handler:((Int) -> ())? = nil) {
        if let window = UIApplication.shared.delegate?.window,
            let rootVC = window!.rootViewController {
            rootVC.presentAlerttt(title: title, message: message, cancelButtonTitle: cancelButtonTitle,
                    otherButtonTitles: otherButtonTitles, handler: handler)
        }
    }

    public func presentAlerttt(title: String?, message: String?, cancelButtonTitle: String, otherButtonTitles: [String]?, handler: ((Int) -> ())?) {

        let op = OOperation()
        op.execution = { finished in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { alert in
                handler?(0)
                finished()
            })
            alert.addAction(cancelAction)

            if let titles = otherButtonTitles {
                for (index, title) in titles.enumerated() {
                    let action = UIAlertAction(title: title, style: .default, handler: { (alert) -> Void in
                        handler?(index + 1)
                        finished()
                    })
                    alert.addAction(action)
                }
            }

            self.present(alert, animated: true, completion: nil)
        }

        alertQueue.addOperation(op)
    }

}
