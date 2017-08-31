//
//  UICollectionView.swift
//  UIKitExtensions
//
//  Created by mac on 8/31/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func verticalScrollCellToVisible(at indexPath: IndexPath) {
        guard let attributes = layoutAttributesForItem(at: indexPath) else { return }
        let cellFrame = attributes.frame

        if cellFrame.minY < bounds.minY {
            scrollToItem(at: indexPath, at: .top, animated: true)
        } else if cellFrame.maxY > bounds.maxY {
            scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
}
