//
//  SignUpVM.swift
//  SLS
//
//  Created by Hady on 2/11/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class SignUpVM {
    
    static func handleCheckBoxBtn (checkBoxBtn : UIButton) {
        checkBoxBtn.layer.borderWidth = 2
        checkBoxBtn.layer.borderColor = UIColor(red : 0 , green: 1, blue: 0, alpha: 0.25).cgColor
        checkBoxBtn.layer.cornerRadius = 8
    }
    
    static func checkCheckBoxStatus(checkBoxBtn : UIButton){
        if checkBoxBtn.isSelected {
            checkBoxBtn.setBackgroundImage(nil, for: .normal)
        } else {
            checkBoxBtn.setBackgroundImage(UIImage(named:"Checkmark-1"), for: .normal)
            
        }
        checkBoxBtn.isSelected = !checkBoxBtn.isSelected
    }
    
 
}
