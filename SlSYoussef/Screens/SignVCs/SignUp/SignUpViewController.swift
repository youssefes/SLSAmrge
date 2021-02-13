//
//  SignUpViewController.swift
//  SLS
//
//  Created by youssef on 2/11/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var loginLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLable()
        
    }

    func setUpLable(){
        let attrbiutedTitle = NSMutableAttributedString(string: "SLS ", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 248/255, green: 153/255, blue: 192/255, alpha: 1) ])
        attrbiutedTitle.append(NSAttributedString(string: "Livestream", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.black]))
        
        loginLbl.attributedText = attrbiutedTitle
    }

    @IBAction func signInWithFacebook(_ sender: Any) {
    }
    
    @IBAction func signInWithGooogle(_ sender: Any) {
    }
    @IBAction func signInWithE_mail(_ sender: Any) {
    }
}
