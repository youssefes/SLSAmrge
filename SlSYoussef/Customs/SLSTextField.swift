//
//  SLSTextField.swift
//  SLS
//
//  Created by Hady on 2/4/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class SLSTextField: UITextField {

   override init(frame: CGRect) {
          super.init(frame: frame)
          configure()
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      
      private func configure(){
          translatesAutoresizingMaskIntoConstraints = false
          layer.cornerRadius = 10
          layer.borderWidth  = 2
          layer.borderColor  = UIColor.systemPurple.cgColor // for core graphics
          
          
          textColor     = .systemPurple // white in normal black in night mode
        if #available(iOS 13.0, *) {
            tintColor     = .label
        } else {
            // Fallback on earlier versions
        }
          textAlignment = .center
          font          = UIFont(name: "kefa", size: 16)
    
          
          adjustsFontSizeToFitWidth = true
          
          minimumFontSize    = 12
          returnKeyType      = .go
        if #available(iOS 13.0, *) {
            backgroundColor    = .tertiarySystemBackground
        } else {
            // Fallback on earlier versions
        }
          autocorrectionType = .no
          clearButtonMode    = .whileEditing
          placeholder = "Price?"
      }
}
