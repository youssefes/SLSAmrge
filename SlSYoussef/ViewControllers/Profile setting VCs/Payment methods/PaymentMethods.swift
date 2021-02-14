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
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           navigationController?.setNavigationBarHidden(true, animated: true)
       }

       
       @IBAction func classBtn(_ sender: Any) {
       }
       
       @IBAction func dismissBtn(_ sender: Any) {
           navigationController?.popViewController(animated: true)
       }
    

}
