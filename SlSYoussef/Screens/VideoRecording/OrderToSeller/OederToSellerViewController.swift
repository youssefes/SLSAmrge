//
//  OederToSellerViewController.swift
//  SLS
//
//  Created by youssef on 2/11/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class OederToSellerViewController: UIViewController {

    @IBOutlet weak var orderCostlbl: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var imageOfBuy: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptBtn(_ sender: Any) {
        let wating = WatingAcceptOrderViewController()
        wating.modalPresentationStyle = .overFullScreen
        present(wating, animated: true, completion: nil)
    }
    
    
    @IBAction func deniedBtn(_ sender: Any) {
    }
    
}
