//
//  ViewController.swift
//  EventOrganizer
//
//  Created by Bob Oror on 1/5/21.
//  Copyright © 2021 Bob. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LogIn: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgetPassBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var containerViewOfEmailTf: UIView!
    @IBOutlet weak var containerViewOfPasswordTf: UIView!
    var isCheckted : Bool = false
    
@IBOutlet weak var loginLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCustomTVRegisteration(rightSideBtnTitle: "SIGN UP")
        Utility.designSingsButtons(logInBtn)
        self.tapGestureOnScreen()
        
 
        checkBoxBtn.layer.borderWidth = 2
        checkBoxBtn.layer.borderColor = UIColor(red : 0 , green: 1, blue: 0, alpha: 0.25).cgColor
        checkBoxBtn.layer.cornerRadius = 8
        setUpLable()
        
    }
    @IBAction func dissmisBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil
        )
    }
    
    
    @IBAction func ShowSignUp(_ sender: Any) {
        let signUp = SignUpViewController()
        signUp.modalPresentationStyle = .overFullScreen
        present(signUp, animated: true, completion: nil)
        
    }
    func setUpLable(){
          let attrbiutedTitle = NSMutableAttributedString(string: "SLS ", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 248/255, green: 153/255, blue: 192/255, alpha: 1) ])
          attrbiutedTitle.append(NSAttributedString(string: "Livestream", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.black]))
          
          loginLbl.attributedText = attrbiutedTitle
      }
    
    func didFailedValidation(text : String){
        errorLabel.text = text
        errorImage.isHidden = false
        containerViewOfEmailTf.borderColor  = .red
        containerViewOfPasswordTf.borderColor = .red
    }
    
    func SuccessValidation() {
        errorLabel.text = ""
        errorImage.isHidden = true
        containerViewOfEmailTf.borderColor  = .green
        containerViewOfPasswordTf.borderColor = .green
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
       isCheckted = !isCheckted
        
        if isCheckted{
            sender.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.7647058824, blue: 0.6274509804, alpha: 1)
            sender.setImage(#imageLiteral(resourceName: "DoneIcon"), for: .normal)
        }else{
            sender.backgroundColor = .white
            sender.setImage(#imageLiteral(resourceName: "DoneIcon"), for: .normal)
        }
    }
    
    
    
    @IBAction func LogInBtn(_ sender: Any) {
        guard let Email = email.text?.trimmingCharacters(in: CharacterSet.whitespaces), !Email.isEmpty else {
            didFailedValidation(text: "Email is empty Please enter your email!")
            return
        }

        guard let Password = password.text, !Password.isEmpty else {
            didFailedValidation(text: "Password is empty , please enter your password!")
            return
        }
        
        SuccessValidation()
        

        Auth.auth().signIn(withEmail: Email, password: Password) { (user, error) in
            if error != nil {
               
                self.didFailedValidation(text: error!.localizedDescription)
                 self.errorImage.isHidden = true
                print(error!.localizedDescription)
            } else {
                let dp = Firestore.firestore()
                let uid = user?.user.uid
                
                if let uid = uid {
                     self.showLoadingView(is: true)
                    print(uid)
                    dp.collection("Users").document(uid).getDocument { (snapshot, error) in
                        if  error == nil {
                            if let document = snapshot , document.exists {
                                if let finalCod = document.data(){
                                    let username : String = finalCod["userName"] as! String
                                    print(username)
                                    let home = HomeViewController()
                                    let navigation = UINavigationController(rootViewController: home)
                                    navigation.modalPresentationStyle = .overFullScreen
                                    self.present(navigation, animated: true, completion: nil)
                                    UtilityFunctions.isLoggedIn = true
                                }
                                
                            }
                            
                        }else{
                            self.showAlert(title: "Error", message: error!.localizedDescription)
                            
                        }
                    }
                }
                
                //  self.showAlert(titel: "Error", message: "Your account not supported")
                //print("\(uid)")
            }
        }
    }
    
    
    
    
}
