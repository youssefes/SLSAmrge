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
import Firebase


class PostVC: UIViewController , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    @IBOutlet weak var containerPrice: UIView!
    
    @IBOutlet weak var loading: LoadingView!
    var containerPriceIshidden  = true
    let textViewPlaceHolder = "What's on your mind?"
    let imagePicker         = ImagePickerController()
    var imagesArray         = [UIImageView]()
    var userUid             = ""
    var arrayOfUrl : [String] = []
    var seccesUploadImage = false
    
    let rootRef = Firestore.firestore().collection("posts").document()
    var viewModel : PostViewModel = PostViewModel()
    @IBOutlet weak var userTextView: UITextView!
    @IBOutlet weak var writeSomethingLabel: UILabel!
    
    //Stack View items
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    let CellIdentifier = "mageCellOfPostCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCollectionView()
        viewModel.ViewDidLoadbind()
        loading.loadingView.stopAnimating()
        
    }
    
    //Stack View functions
    
    @IBAction func publishBtn(_ sender: Any) {
        loading.loadingView.startAnimating()
        if imagesArray.count > 0 {
            imagesArray.forEach { (Image) in
                guard let image = Image.image else {return}
                viewModel.uplaoadImage(image: image, complactionhandle: { [weak self] (seccess, url) in
                    guard let self = self else {return}
                    if seccess {
                        guard let urlOfImage = url else {return}
                        self.arrayOfUrl.append(urlOfImage)
                        if self.arrayOfUrl.count == self.imagesArray.count {
                            self.createPost()
                        }
                    }else{
                        print("error in uploading")
                    }
                })
            }
             
        }else {
            self.createPost()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        FetchUserData.fetchFBUserData { [weak self] (userData) in
            guard let self = self else {return}
            guard let uid = userData?.uid else {return}
            self.userUid = uid
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    func createPost(){
        let postId  = rootRef.documentID
        if let posttext = userTextView.text, !imagesArray.isEmpty, !posttext.isEmpty {
            rootRef.setData(["id" : postId , "user" : userUid ,"context" : ["text" : posttext ,"img" : arrayOfUrl], "price" : priceTextField.text ?? "", "date" : Date.timeIntervalBetween1970AndReferenceDate]) { [weak self](error) in
                guard let self = self else{return}
                if error == nil{
                    self.loading.loadingView.stopAnimating()
                    self.showAlert(title: "seccess", message: "post upload seccessfully")
                      self.userTextView.text = ""
                    self.imagesArray = []
                    self.imagesCollectionView.reloadData()
                    self.priceTextField.text = ""
                }else{
                    self.loading.loadingView.stopAnimating()
                    self.showAlert(title: "error in create post ", message: error!.localizedDescription)
                  
                }
            }
            
        }else if !imagesArray.isEmpty {
            rootRef.setData(["id" : postId ,"user" : userUid ,"context" : ["text" : "" ,"img" : arrayOfUrl],"price" : priceTextField.text ?? "", "date" : Date.timeIntervalBetween1970AndReferenceDate]) { [weak self] (error) in
                 guard let self = self else{return}
                if error == nil{
                    self.loading.loadingView.stopAnimating()
                    self.showAlert(title: "seccess", message: "post upload seccessfully")
                      self.userTextView.text = ""
                    self.imagesArray = []
                    self.imagesCollectionView.reloadData()
                    self.priceTextField.text = ""
                }else{
                    self.loading.loadingView.stopAnimating()
                    self.showAlert(title: "error in create post ", message: error!.localizedDescription)
                }
            }
        }else if let posttext = userTextView.text ,!posttext.isEmpty {
            rootRef.setData(["id" : postId ,"user" : userUid ,"context" : ["text" : posttext ,"img" : []], "price" : priceTextField.text ?? "" , "date" : Date.timeIntervalBetween1970AndReferenceDate]) { [weak self] (error) in
                 guard let self = self else{return}
                if error == nil{
                    self.loading.loadingView.stopAnimating()
                    self.showAlert(title: "seccess", message: "post upload seccessfully")
                }else{
                    self.loading.loadingView.stopAnimating()
                    self.showAlert(title: "error in create post ", message: error!.localizedDescription)
                     self.userTextView.text = ""
                      self.userTextView.text = ""
                    self.priceTextField.text = ""
                }
            }
            
        }else{
            self.showAlert(title: "error in uploading Post", message: "you most write same thing or choose photes to upload them in post")
              loading.loadingView.stopAnimating()
        }
    }
    
    
    @IBAction func dissmisBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func priceButton(_ sender: Any) {
        containerPriceIshidden = !containerPriceIshidden
        if containerPriceIshidden {
            UIView.animate(withDuration: 0.5) {
                self.containerPrice.isHidden = true
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.containerPrice.isHidden = false
            }
        }
        
    }
    
    func configurePriceStack(){
        
        UIView.animate(withDuration: 0.5){
            
        }
    }
        
    
    @IBAction func selectPictureButton(_ sender: Any) {
        presentImagePickerVC()
    }
    
    private func configureVC(){
        gestureAnyWhereInTheScreen()
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
        if imagesArray.count == 2{
            let width = (collectionView.frame.width - 10)
            return CGSize(width: width, height: width / 2)
        }else if imagesArray.count == 1{
            let width = (collectionView.frame.width) / 1
            return CGSize(width: width, height: width)
        }else{
            if indexPath.item == 0 {
                let width = (collectionView.frame.width)
                return CGSize(width: width, height: width / 2)
            }else{
                if imagesArray.count == 3 {
                    let width = (collectionView.frame.width - 10) / 2
                    return CGSize(width: width, height: width)
                }else{
                    let width = (collectionView.frame.width - 10) / 3
                    return CGSize(width: width, height: width)
                }
                
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  CellIdentifier, for: indexPath) as! mageCellOfPostCollectionViewCell
        cell.imageOfPost.image = imagesArray[indexPath.row].image
        
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



