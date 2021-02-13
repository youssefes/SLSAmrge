//
//  Profile.swift
//  EventOrganizer
//
//  Created by Bob Oror on 1/6/21.
//  Copyright © 2021 Bob. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Profile: UIViewController {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Email: UILabel!
    
    let ref = Database.database().reference().child("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    
    func loadData() {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let email = user.email
            let ref2 = Database.database().reference().child("Users").child(uid)
            Email.text = email
            
            ref2.child("Name").observe(.value) { (snapshot) in
                self.Name.text = "\(snapshot.value!)"
            }
        }
        
    }

}
