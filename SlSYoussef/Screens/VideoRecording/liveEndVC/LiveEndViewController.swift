//
//  LiveEndViewController.swift
//  SLS
//
//  Created by youssef on 2/11/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

protocol LiveEndViewProtocal : class {
    func endLive()
}

class LiveEndViewController: UIViewController {
    
    weak var Deleget : LiveEndViewProtocal?
    
    @IBOutlet weak var viewsNumberlbl: UILabel!
    
    @IBOutlet weak var dirationlbl: UILabel!
    @IBOutlet weak var erninglbl: UILabel!
    @IBOutlet weak var numberofOrders: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func saveInmyStreamSwitch(_ sender: UISwitch) {
        
    }
    
    
    
    @IBAction func dismisBtn(_ sender: Any) {
        dismiss(animated: true) {
            self.Deleget?.endLive()
        }
    }
}
