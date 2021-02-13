//
//  WatingAcceptOrderViewController.swift
//  SLS
//
//  Created by youssef on 2/11/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class WatingAcceptOrderViewController: UIViewController {
    @IBOutlet weak var orderNumberlbl: UILabel!
    
    @IBOutlet weak var loadingView: LoadingView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
