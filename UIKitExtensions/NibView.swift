//
//  NibView.swift
//  UIKitExtensions
//
//  Created by mac on 1/4/18.
//  Copyright © 2018 arkdan. All rights reserved.
//

import UIKit

open class NibView: UIView {

    @IBOutlet public weak var contentView: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibInit()
    }

    private func nibInit() {
        Bundle.main.loadNibNamed(type(of: self).identifier, owner: self, options: nil)
        addSubview(contentView)
        pin(subview: contentView)
    }
}
