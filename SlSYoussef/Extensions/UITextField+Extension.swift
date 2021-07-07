//
//  UITextField+Extension.swift
//  Opportunities
//
//  Created by youssef on 12/19/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation
import UIKit
import InputBarAccessoryView
class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

extension InputBarAccessoryView {
    
    open override func alignmentRect(forFrame frame: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
}
