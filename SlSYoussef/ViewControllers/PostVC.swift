//
//  ViewController.swift
//  SLS
//
//  Created by Hady on 1/24/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos


class PostVC: UIViewController , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    
    let textViewPlaceHolder = "What's on your mind?"
    let imagePicker         = ImagePickerController()
    var imagesArray         = [UIImageView]()

    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var userTextView: UITextView!
    @IBOutlet weak var writeSomethingLabel: UILabel!
    
    //Stack View items
    @IBOutlet weak var selectEmojyButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
//    let priceSignLabel = PriceLabel(textAlignment: .center)
    @IBOutlet weak var priceStack: UIStackView!
    @IBOutlet weak var priceTextField: UITextField!
    
    let CellIdentifier = "mageCellOfPostCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userTextView.delegate   = self
        configureVC()
        configureCollectionView()
    }
    //Stack View functions
    

    
    
    @IBAction func priceButton(_ sender: Any) {
        configurePriceStack()
    }
    
    func configurePriceStack(){
        
        UIView.animate(withDuration: 0.5){
//            if self.priceTextField.isEnabled {
//                self.priceTextField.isEnabled   = false
//                self.priceTextField.borderStyle = .none
//                self.priceTextField.text        = .none
//                //self.priceTextField.layer.borderWidth  = 0
//                self.priceTextField.layer.borderColor  = .none // for core graphics
//                self.priceTextField.resignFirstResponder()
//                self.priceSignLabel.removeFromSuperview()
//                self.view.layoutIfNeeded()
//
//            } else {
//                self.priceSignLabel.text        = "$"
//                self.priceStack.addArrangedSubview(self.priceSignLabel)
//                self.priceTextField.isEnabled   = true
//                self.priceTextField.borderStyle = .roundedRect
//                //self.priceTextField.layer.borderWidth  = 2
//                self.priceTextField.layer.borderColor  = UIColor.systemPink.cgColor // for core graphics
//                self.priceTextField.becomeFirstResponder()
//                self.view.layoutIfNeeded()
//            }
//            UtilityFunctions.configureLabelAnimation(textField: self.priceTextField, label: self.priceSignLabel, stack: self.priceStack, view: self.view)
        }
    }
        
    @IBAction func selectEmojyButton(_ sender: Any) {
        let configVC = ProfileSetting()
        navigationController?.pushViewController(configVC, animated: true)
    }
    
    @IBAction func discardButton(_ sender: Any) {
        presentAlertOnMainThread(title: "Discard", message: "Are you sure you want to dicard the post?", leftTitle: "Yes", rightTitle: "No")
    }
    
    @IBAction func selectPictureButton(_ sender: Any) {
        presentImagePickerVC()
    }
    
    private func configureVC(){
        publishButton.layer.cornerRadius = 15
        gestureAnyWhereInTheScreen()
        creatNavigationBarButtons()
        Utility.configureUserTextView(userTextView, placeholder: textViewPlaceHolder)
    }
    
    @objc func presentImagePickerVC(){
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
            print("user Selected an asset")
            self.imagesArray.removeAll()
            
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
            print("User deselected an asset")
        }, cancel: { (assets) in
            self.imagesArray.removeAll()
            self.imagesCollectionView.reloadData()
            print("User canceled selection")
            
        }, finish: { (assets) in
            // User finished selection assets.
            self.imagesArray.removeAll()
            self.imagesCollectionView.reloadData()
            print("User finished selection assets.")
            self.configureImageViews(assets)
        })
        
    }
    
    func configureImageViews(_ assets : [PHAsset]){
        let numOfImages = assets.count
        for idx in 0...numOfImages - 1 {
            let pickedImage : UIImageView? = UIImageView(image: UtilityFunctions.handlePHImageManager(asset: assets[idx]))
            if let pImage = pickedImage {
                imagesArray.append(pImage)
                print("loob number \(idx)")
            }
        }
        imagesCollectionView.reloadData()
    }
    
    //MARK: - Collection View Configurations
    private func configureCollectionView(){
        imagesCollectionView.delegate   = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: "mageCellOfPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0,1:
            return CGSize(width: (imagesCollectionView.bounds.width - 16) / 2, height: (imagesCollectionView.bounds.width  - 16) / 2)
        default:
            return CGSize(width: (imagesCollectionView.bounds.width - 32) / 3, height:  (imagesCollectionView.bounds.width ) / 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imagesArray.count > 5 { collectionView.reloadData()  ; return 5}
        
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  CellIdentifier, for: indexPath) as! mageCellOfPostCollectionViewCell
        cell.imageOfPost.image = imagesArray[indexPath.row].image
        
//        if  indexPath.row == 4 , imagesArray.count > 5 {  cell.idk.backgroundColor = .lightGray ; cell.idk.text = "+\(imagesArray.count - 5)"}
//        else { cell.idk.backgroundColor = .none ; cell.idk.text = "" }
        
        print("Access indexPath \(indexPath.row)")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item")
        presentImagePickerVC()
    }
    //MARK: - ViewController Configuration
    
    
    func gestureAnyWhereInTheScreen(){
        let gesture = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:)))
        view.addGestureRecognizer(gesture)
    }
    
}






extension PostVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView){
        //This is TextView Placeholder
        if (textView.text == textViewPlaceHolder && textView.textColor == .lightGray){
            textView.text = ""
            if #available(iOS 13.0, *) {
                textView.textColor = .label
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if (textView.text == ""){
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}



