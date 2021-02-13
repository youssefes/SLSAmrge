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
    
    
    let dp  = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.designSingsButtons(signUpBtn)
        self.createCustomTVRegisteration(rightSideBtnTitle: "LOG IN")
        self.tapGestureOnScreen()
        tapGestureInImage()
        SignUpVM.handleCheckBoxBtn(checkBoxBtn: checkBoxBtn)
        
    }
    
    @IBAction func UploadImage(_ sender: Any) {
        handleUploadImage()
    }

    
    func validateFields() -> String? {
        guard IdImage.image != UIImage(named: "profile img") else {
            return "Please upload your ID image"
        }
        
        guard IdButton.tintColor == UIColor.blue else {
            return "Please upload your ID image"
        }
        
        if name.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            name.layer.borderColor = UIColor.red.cgColor
            name.layer.borderWidth = 1
            return "Please enter your name"
        }
        name.layer.borderWidth = 0
        
        if mail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            mail.layer.borderColor = UIColor.red.cgColor
            mail.layer.borderWidth = 1
            return "Please enter your E-mail address"
        }
        mail.layer.borderWidth = 0
        
        let cleanPassword = pass.text!
        if  UtilityFunctions.isPasswordValid(cleanPassword) == false {
            pass.layer.borderColor = UIColor.red.cgColor
            pass.layer.borderWidth = 1
            return "make sure that your password is at least 8 characters containig special characters and numbers"
        }
        pass.layer.cornerRadius = 0
        
        guard checkBoxBtn.isSelected else {
            checkBoxBtn.layer.borderColor = UIColor.red.cgColor
            return "We user terms of use to keep you secured, in order to use the app you have to accept these terms"
        }
        checkBoxBtn.layer.borderColor = UIColor.green.cgColor
        return nil
    }
    
    @IBAction func termsCheckBox(_ sender: UIButton) {
        SignUpVM.checkCheckBoxStatus(checkBoxBtn: checkBoxBtn)
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        
        let error  = validateFields()
        if  error != nil {
            errorLabel.text = error!
            errorImg.image  = UIImage(named: "redExclamation")
        }
        else {
            let validName  = name.text!.trimmingCharacters(in: .whitespaces)
            let validEmail = mail.text!.trimmingCharacters(in: .whitespaces)
            let validPass  = pass.text!
            self.errorLabel.text = ""
            self.errorImg.image  = nil
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
                            self.uploadImage(userUid: "\(result.user.uid)")
                        }
                    }else { print("error with result \(String(describing: result))") }
                }else { self.showAlert(title: "First Error is Not nil!", message: error!.localizedDescription) ; }
            }
        }
        print("Done registeration cycle")
        
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
    
    @objc func uploadImage(userUid : String){
        guard let image = IdImage.image , let data = image.jpegData(compressionQuality: 1.0 ) else{
            self.showAlert(title: "Error", message: "Something went wrong uploading image")
            return
        }
        
        let imageName    = UUID().uuidString
        let imgReference = Storage.storage().reference().child("UsersRefs").child(imageName)
        
        imgReference.putData(data, metadata: nil) { (metaData, error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            imgReference.downloadURL { (url, error) in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                
                guard let url = url else {
                    self.showAlert(title: "Error", message: "Something wrong with url!")
                    return
                }
                
                let urlString = url.absoluteString
                
                
                let dataref = Firestore.firestore().collection("user").document(userUid)
                
                let data = ["profilPic" :  urlString]
                
                dataref.setData(data, merge: true) { (error) in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                }
                self.terminateRegisteration()
                //self.showAlert(title: "Success", message: "User Created!")
                let headToQuit = RegisterationCompletedViewController()
                self.present(headToQuit, animated: true)
                UserDefaults.standard.setValue(userUid, forKey: "imgUid")
                
            }
            
        }
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
