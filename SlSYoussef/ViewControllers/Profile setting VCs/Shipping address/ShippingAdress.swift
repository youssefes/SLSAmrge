//
//  ShippingAdress.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import UITextView_Placeholder
class ShippingAdress: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCustomTitleViewInEditProfile(with: "Shipping adress")
        self.tapGestureOnScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func closeBtn(_ sender: Any) {
    }
    
}
