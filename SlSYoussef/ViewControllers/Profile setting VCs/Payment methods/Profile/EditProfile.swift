//
//  EditProfile.swift
//  SLS
//
//  Created by Hady on 2/8/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class EditProfile: UIViewController  {
    
    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var dateOfBirthTF: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    let editProfileVM = EditProfileVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCustomTitleViewInEditProfile(with: "Edit profile")
        editProfileVM.configureImageView(userImage: userImage)
        editProfileVM.tapGestureOnScreen(view: self.view)
        Utility.designSingsButtons(saveBtn)
        tapGestureInImage()
    }
    
    @IBAction func uploadImageButton(_ sender: Any) {
        handleUploadImage()
    }
    
    
    
    @IBAction func save(_ sender: Any) {
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
