//
//  PaymentMethods.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class PaymentMethods: UIViewController {

    @IBOutlet weak var payPalBtn: UIButton!
    @IBOutlet weak var creditCardBtn: UIButton!
    let paymentMethodsVM = PaymentModelVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCustomTitleViewInEditProfile(with: "Payment methods")
        self.tapGestureOnScreen()
        paymentMethodsVM.configurePaymentMethods(btn: payPalBtn)
        paymentMethodsVM.configurePaymentMethods(btn: creditCardBtn)
    }

}
