//
//  TitleLabel.swift
//  SLS
//
//  Created by Hady on 25/1/20.
//  Copyright © 2020 HadyOrg. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment : NSTextAlignment , fontSize : CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    private func configure(){
        if #available(iOS 13.0, *) {
            textColor                 = .label
        } else {
            // Fallback on earlier versions
        }
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor        = 0.9
        lineBreakMode             = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
