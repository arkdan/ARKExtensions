//
//  NibView.swift
//  UIKitExtensions
//
//  Created by mac on 1/4/18.
//  Copyright © 2018 arkdan. All rights reserved.
//

import UIKit

open class SetupView: UIView {

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

open class SetupCollectionCell: UICollectionViewCell {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // UICollectionViewCell outlets are still nil on init(coder: ). We need to call setup() on awakeFromNib
    private var shouldSetupOnAwakeFromNib = false
    public required init?(coder aDecoder: NSCoder) {
        shouldSetupOnAwakeFromNib = true
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        if shouldSetupOnAwakeFromNib {
            setup()
        }
    }

    open func setup() {
    }
}

open class SetupTableCell: UITableViewCell {

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    // UITableViewCell outlets are still nil on init(coder: ). We need to call setup() on awakeFromNib
    private var shouldSetupOnAwakeFromNib = false
    public required init?(coder aDecoder: NSCoder) {
        shouldSetupOnAwakeFromNib = true
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        if shouldSetupOnAwakeFromNib {
            setup()
        }
    }

    open func setup() {
    }
}

open class NibView: SetupView {

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
