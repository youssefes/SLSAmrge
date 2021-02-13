//
//  SecondaryLabel.swift
//  SLS
//
//  Created by Hady on 1/25/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class SecondaryLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fontSize : CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        configure()
    }
    private func configure(){
        if #available(iOS 13.0, *) {
            textColor                 = .secondaryLabel
        } else {
            // Fallback on earlier versions
        }
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor        = 0.90
        numberOfLines             = 0
        lineBreakMode             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
