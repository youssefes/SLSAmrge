//
//  BodyLabel.swift
//  SLS
//
//  Created by Hady on 25/1/20.
//  Copyright © 2020 HadyOrg. All rights reserved.
//

import UIKit

class BodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAlignment : NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    private func configure(){
        if #available(iOS 13.0, *) {
            textColor                 = .secondaryLabel
        } else {
            // Fallback on earlier versions
        }
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor        = 0.75
        lineBreakMode             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
