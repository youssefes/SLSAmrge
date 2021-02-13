//
//  Utility.swift
//  SLS
//
//  Created by Hady on 2/3/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

struct Utility {
    
   static func designSingsButtons (_ button : UIButton) {
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
    }
    
    static func configureUserTextView(_ userTextView : UITextView , placeholder : String) {
        userTextView.text               = placeholder
        userTextView.textColor          = .lightGray
        userTextView.font               = UIFont.systemFont(ofSize: 18)
        userTextView.layer.borderColor  = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        userTextView.layer.borderWidth  = 2.0
        userTextView.layer.cornerRadius = 5
        
        userTextView.sizeThatFits(CGSize(width: userTextView.frame.size.width, height: userTextView.frame.size.height))
    }
    
    
}
