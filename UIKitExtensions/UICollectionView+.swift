//
//  UICollectionView.swift
//  UIKitExtensions
//
//  Created by mac on 8/31/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import UIKit

extension UICollectionView {

    public func scrollToBottom(animated: Bool = true) {
        let lastsection = numberOfSections - 1
        guard lastsection >= 0 else { return }

        let lastItem = numberOfItems(inSection: lastsection) - 1
        guard lastItem >= 0 else { return }

        let indexPath = IndexPath(row: lastItem, section: lastsection)
        scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }

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

extension UICollectionView {

    public func registerNib(_ type: UICollectionViewCell.Type) {
        register(UINib(nibName: type.identifier, bundle: nil), forCellWithReuseIdentifier: type.identifier)
    }

    public func registerClass(_ type: UICollectionViewCell.Type) {
        register(type, forCellWithReuseIdentifier: type.identifier)
    }

    public func dequeueCell<CellType: UICollectionViewCell>(type: CellType.Type, indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withReuseIdentifier: CellType.identifier, for: indexPath) as! CellType
    }
}

extension UITableView {

    public func registerNib(_ type: UITableViewCell.Type) {
        register(UINib(nibName: type.identifier, bundle: nil), forCellReuseIdentifier: type.identifier)
    }

    public func registerClass(_ type: UITableViewCell.Type) {
        register(type, forCellReuseIdentifier: type.identifier)
    }

    public func dequeueCell<CellType: UITableViewCell>(type: CellType.Type, indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as! CellType
    }
}
