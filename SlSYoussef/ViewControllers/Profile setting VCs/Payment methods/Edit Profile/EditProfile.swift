//
//  EditProfile.swift
//  SLS
//
//  Created by Hady on 2/8/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
class EditProfile: UIViewController  {
    
    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var dateOfBirthTF: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    let dp = Firestore.firestore()
    let editProfileVM = EditProfileVM()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfileVM.configureImageView(userImage: userImage)
        editProfileVM.tapGestureOnScreen(view: self.view)
        Utility.designSingsButtons(saveBtn)
        tapGestureInImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func dismiswbtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func uploadImageButton(_ sender: Any) {
        handleUploadImage()
    }
    
    var data = [String:String]()
    @IBAction func save(_ sender: Any) {
        if currentUserIsValid() {
            if let txt = usernameTF.text , txt.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                data[User.userName] = txt
            }
            
            if let txt = fullnameTF.text , txt.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                data[User.fullName] = txt
            }
            
            if let txt = emailTF.text , txt.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                data[User.fullName] = txt
            }
            
            if let txt = phoneNumberTF.text , txt.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                data[User.phoneNumber] = txt
            }
            
            if let txt = dateOfBirthTF.text , txt.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                data[User.dateOfBirth] = txt
            }
            
            dp.collection("user").document(currentlyUserUid!).setData(data, merge: true) { (err) in
                self.showAlert(title: "Error" , message: err!.localizedDescription)
            }
            
        }
        else {self.showAlert(title: "Error", message: "Please check your internet connection and try again")}
    }
    
    func tapGestureInImage(){
        userImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self.view, action: #selector(imageGesture))
        gesture.numberOfTapsRequired = 1
        userImage.addGestureRecognizer(gesture)
    }
    
    @objc func imageGesture(){
        handleUploadImage()
    }
    
}

extension EditProfile :  UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImage.image = chosenimage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func handleUploadImage(){
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
    
    
}
