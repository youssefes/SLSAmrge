//
//  CustomerSupport.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class CustomerSupport: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
    }
    
    
    @IBAction func dissmisBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
