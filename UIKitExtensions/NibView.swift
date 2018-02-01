//
//  NibView.swift
//  UIKitExtensions
//
//  Created by mac on 1/4/18.
//  Copyright © 2018 arkdan. All rights reserved.
//

import UIKit

open class HookedView: UIView {

    open var setupClosure: ((UIView) -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }

    private func initSetup() {
        setup()
        setupClosure?(self)
    }

    open func setup() {
    }
}

open class HookedCollectionCell: UICollectionViewCell {

    open var setupClosure: ((UIView) -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetup()
    }

    private func initSetup() {
        setup()
        setupClosure?(self)
    }

    open func setup() {
    }
}

open class NibView: HookedView {

    @IBOutlet public weak var contentView: UIView!

    open var nibName: String {
        return type(of: self).identifier
    }

    override open func setup() {
        super.setup()
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        pin(subview: contentView)
    }
}
