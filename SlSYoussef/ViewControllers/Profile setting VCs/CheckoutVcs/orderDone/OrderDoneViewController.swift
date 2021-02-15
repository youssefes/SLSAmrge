//
//  OrderDoneViewController.swift
//  SlSYoussef
//
//  Created by youssef on 2/15/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class OrderDoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
           navigationController?.popViewController(animated: true)
       }
       

    @IBAction func myOrders(_ sender: Any) {
    }
    
}
