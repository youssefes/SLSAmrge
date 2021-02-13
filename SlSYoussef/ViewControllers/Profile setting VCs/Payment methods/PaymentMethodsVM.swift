//
//  PaymentMethodsVM.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

struct PaymentModelVM {
   
    public func configurePaymentMethods(btn : UIButton){
        btn.layer.cornerRadius = 7
        btn.clipsToBounds      = true
        btn.layer.borderColor  = UIColor.darkGray.cgColor
        btn.layer.borderWidth  = 1
    }
}
