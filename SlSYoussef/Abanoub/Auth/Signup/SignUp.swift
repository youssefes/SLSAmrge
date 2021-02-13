//
//  SignUp.swift
//  EventOrganizer
//
//  Created by Bob Oror on 1/5/21.
//  Copyright © 2021 Bob. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn

class SignUp: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var IdImage: UIImageView!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var IdButton: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorImg: UIImageView!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var loginLbl: UILabel!
    
    @IBOutlet weak var containerViewOfPasswirdTf: UIView!
    @IBOutlet weak var containerViewOfEmailTf: UIView!
    @IBOutlet weak var containerViewOfUserTf: UIView!
    var isCheckted = false
    let dp  = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.designSingsButtons(signUpBtn)
        self.createCustomTVRegisteration(rightSideBtnTitle: "LOG IN")
        self.tapGestureOnScreen()
        tapGestureInImage()
    }
    
    @IBAction func UploadImage(_ sender: Any) {
        handleUploadImage()
    }
    
    @IBAction func dissmisBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil
        )
    }
    
    
    @IBAction func ShowSignUp(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signIn = sb.instantiateViewController(withIdentifier: "LogIn")
        signIn.modalPresentationStyle = .overFullScreen
        present(signIn, animated: true, completion: nil)
        
    }
    
    
    func validateFields() -> Bool {
        guard IdImage.image != UIImage(named: "profile img") else {
            didFailedValidation(text: "Please upload your ID image")
            return false
        }
        guard IdButton.tintColor == UIColor.blue else {
            didFailedValidation(text: "Please upload your ID image")
            return false
        }
        
        guard let nameText = name.text, !nameText.isEmpty else {
            didFailedValidation(text: "Please enter your name")
            return false
        }
        
        guard let emailText = mail.text, !emailText.isEmpty  else{
            didFailedValidation(text: "Please enter your E-mail address")
            return false
        }
        
        guard let cleanPassword = pass.text, !cleanPassword.isEmpty  else{
            didFailedValidation(text: "Please enter your Password address")
            return false
        }
        guard  UtilityFunctions.isPasswordValid(cleanPassword) == false else{
            didFailedValidation(text: "make sure that your password is at least 8 characters containig special characters and numbers")
            return false
        }
        guard isCheckted else {
            didFailedValidation(text: "We user terms of use to keep you secured, in order to use the app you have to accept these terms")
            return false
        }
        
        return true
    }
    
    @IBAction func termsCheckBox(_ sender: UIButton) {
        isCheckted = !isCheckted
        
        if isCheckted{
            sender.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.7647058824, blue: 0.6274509804, alpha: 1)
            sender.setImage(#imageLiteral(resourceName: "DoneIcon"), for: .normal)
        }else{
            sender.backgroundColor = .white
            sender.setImage(#imageLiteral(resourceName: "DoneIcon"), for: .normal)
        }
    }
    
    func didFailedValidation(text : String){
        errorLabel.text = text
        errorImg.isHidden = false
        containerViewOfEmailTf.borderColor  = .red
        containerViewOfPasswirdTf.borderColor = .red
        containerViewOfUserTf.borderColor = .red
    }
    
    func SuccessValidation() {
        errorLabel.text = ""
        errorImg.isHidden = false
        containerViewOfEmailTf.borderColor  = .green
        containerViewOfPasswirdTf.borderColor = .green
        containerViewOfUserTf.borderColor = .green
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        guard let image = IdImage.image , let data = image.jpegData(compressionQuality: 1.0 ) else{
            self.showAlert(title: "Error", message: "Something went wrong uploading image")
            return
        }
        if validateFields(){
            let validName  = name.text!.trimmingCharacters(in: .whitespaces)
            let validEmail = mail.text!.trimmingCharacters(in: .whitespaces)
            let validPass  = pass.text!
            Auth.auth().createUser(withEmail: validEmail, password: validPass) { (result, error) in
                if error == nil {
                    if let result = result {
                        self.waitUntilFinishRegisteration()
                        self.dp.collection("user").document("\(result.user.uid)").setData(["uid" : result.user.uid,"userName" : validName , "email" : validEmail]){ (er) in
                            guard error == nil else {
                                self.terminateRegisteration()
                                self.showAlert(title: "Error", message: er!.localizedDescription)
                                return
                            }
                            UserRepositoryManger.uploadImage(userUid: result.user.uid, Image: data) { (error, secsess) in
                                if secsess{
                                    let vc = HomeViewController()
                                    vc.modalPresentationStyle = .overFullScreen
                                    self.present(vc, animated: true, completion: nil)
                                }else{
                                    self.showAlert(title: "Sign Up Error", message: "\(error)")
                                }
                            }
                        }
                    }else { print("error with result \(String(describing: result))") }
                }else { self.showAlert(title: "First Error is Not nil!", message: error!.localizedDescription) ; }
            }
        }else{
            
        }
        
    }
    
    
    func waitUntilFinishRegisteration(){
        showLoadingView()
        signUpBtn.isEnabled = false
    }
    
    func terminateRegisteration(){
        hideLoadingView()
        signUpBtn.isEnabled = true
    }
}



//MARK: - Signup all images configuration extnesion
extension SignUp : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func handleUploadImage(){
        IdButton.tintColor = UIColor.blue
        let imagepicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagepicker.sourceType = .camera
        } else {
            imagepicker.sourceType = .photoLibrary
        }
        
        imagepicker.allowsEditing = true
        imagepicker.delegate      = self
        present(imagepicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            IdImage.image = chosenimage
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - VC Gestures on screen
    
    func tapGestureInImage(){
        IdImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageGesture))
        gesture.numberOfTapsRequired = 1
        IdImage.addGestureRecognizer(gesture)
    }
    
    @objc func imageGesture(){
        handleUploadImage()
    }
}
