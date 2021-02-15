//
//  summeryCheckoutViewController.swift
//  SlSYoussef
//
//  Created by youssef on 2/15/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class summeryCheckoutViewController: UIViewController {
    @IBOutlet weak var fullNameTf: UITextField!
    
    @IBOutlet weak var payMentMathod: UITextField!
    @IBOutlet weak var addresstf: UITextField!
    
    @IBOutlet weak var totalLbel: UILabel!
    
    @IBOutlet weak var totaltf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    @IBAction func editFullnamebtn(_ sender: Any) {
        fullNameTf.isEnabled = true
        fullNameTf.textColor = .black
    }
    
    @IBAction func editpayMentBtn(_ sender: Any) {
        payMentMathod.isEnabled = true
        payMentMathod.textColor = .black
    }
    @IBAction func editAddressMethod(_ sender: Any) {
        addresstf.isEnabled = true
        addresstf.textColor = .black
    }
    
    @IBAction func payBtn(_ sender: Any) {
        let OrderDone = OrderDoneViewController()
        navigationController?.pushViewController(OrderDone, animated: true)
        
    }
    
    
}
