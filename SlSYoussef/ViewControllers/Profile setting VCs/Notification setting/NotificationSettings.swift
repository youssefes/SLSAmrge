//
//  NotificationSettings.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class NotificationSettings: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func dismiss(_ sender: Any) {
          navigationController?.popViewController(animated: true)
      }
      
      @IBAction func canselBtn(_ sender: Any) {
      }
    
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(true, animated: true)
      }

}
