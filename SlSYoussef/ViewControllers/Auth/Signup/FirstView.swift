//
//  firstView.swift
//  SLS
//
//  Created by Hady on 2/2/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class FirstView: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.designSingsButtons(logInButton)
        Utility.designSingsButtons(signUpButton)
        UINavigationBar.appearance().isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func logInButton(_ sender: Any) {
        let vc = Notifications()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let signUp = SignUpViewController()
             signUp.modalPresentationStyle = .overFullScreen
             present(signUp, animated: true, completion: nil)
        
    }
    
}
