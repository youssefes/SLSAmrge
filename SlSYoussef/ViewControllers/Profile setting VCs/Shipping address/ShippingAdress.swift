//
//  ShippingAdress.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import Firebase
import FirebaseDatabase
class ShippingAdress: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    let dp = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCustomTitleViewInEditProfile(with: "Shipping adress")
        self.tapGestureOnScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    var data = [String:String]()
    
    
    
    @IBAction func save(_ sender: UIButton) {
        self.showLoadingView()
        if currentUserIsValid() {
            if let txt = textView.text , txt.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                data[User.shippingAddress] = txt
            }
            dp.collection("user").document(currentlyUserUid!).setData(data, merge: true) { (err) in
                if err != nil {
                    self.hideLoadingView()
                    self.showAlert(title: "Error", message: err!.localizedDescription)
                }
                else {
                    self.hideLoadingView()
                    self.showAlert(title: "Success", message: "You successfully updated your data")
                }
            }
        }
    }
    
    var currentlyUserUid : String?
    func currentUserIsValid() -> Bool {
        var isOnline : Bool = false
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.currentlyUserUid = user.uid
                isOnline = true
            }
            else {
                self.showAlert(title: "Error", message: "Something wrong please check your internet connection and try again")
                isOnline = false
            }
            
        }
        return isOnline
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
