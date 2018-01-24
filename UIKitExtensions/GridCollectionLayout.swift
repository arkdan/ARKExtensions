//
//  GridCollectionLayout.swift
//  UIKitExtensions
//
//  Created by mac on 12/8/17.
//  Copyright © 2017 arkdan. All rights reserved.
//

import UIKit

open class GridCollectionLayout: UICollectionViewFlowLayout {

    public var numberOfColumns: Int {
        didSet { invalidate() }
    }
    public var spacing: CGFloat {
        didSet { invalidate() }
    }

    private func invalidate() {
        invalidateLayout()
        collectionView?.invalidateIntrinsicContentSize()
    }

    override open var itemSize: CGSize {
        get {
            let width = columnWidth()
            return CGSize(width, width)
        }
        set {
        }
    }

    public class func `default`() -> GridCollectionLayout {
        return GridCollectionLayout(numberOfColumns: 4, spacing: 2)
    }

    public class func singleColumn() -> GridCollectionLayout {
        return GridCollectionLayout(numberOfColumns: 1, spacing: 0)
    }

    public init(numberOfColumns: Int, spacing: CGFloat) {
        self.numberOfColumns = numberOfColumns
        self.spacing = spacing
        super.init()
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.numberOfColumns = 4
        self.spacing = 2
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        minimumInteritemSpacing = spacing
        minimumLineSpacing = spacing
        scrollDirection = .vertical
    }

    private func columnWidth() -> CGFloat {
        let width = collectionView?.bounds.size.width ?? 0
        let allSpacing = (numberOfColumns - 1).cgFloat * spacing
        return (width - allSpacing) / numberOfColumns.cgFloat
    }
}
