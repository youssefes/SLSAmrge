//
//  SignUpViewController.swift
//  SLS
//
//  Created by youssef on 2/11/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin

class SignUpViewController: UIViewController , GIDSignInDelegate{
    
    @IBOutlet weak var loadingView: LoadingView!
    
    @IBOutlet weak var loginLbl: UILabel!
    
    let loginMangerOfFaceBook = LoginManager()
    
    let dp  = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLable()
        setupLoginWithGoogrl()
        loadingView.loadingView.stopAnimating()
    }
    
    func setupLoginWithGoogrl(){
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func setUpLable(){
        let attrbiutedTitle = NSMutableAttributedString(string: "SLS ", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 248/255, green: 153/255, blue: 192/255, alpha: 1) ])
        attrbiutedTitle.append(NSAttributedString(string: "Livestream", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.black]))
        
        loginLbl.attributedText = attrbiutedTitle
    }
    
    @IBAction func signInWithFacebook(_ sender: Any) {
        self.loadingView.loadingView.startAnimating()
        loginMangerOfFaceBook.logIn(permissions: [], from: self) { [weak self](resulte, error) in
            guard let self = self else {return}
            if error != nil{
                self.showAlert(title: " error on using Facebook", message: "error in Login With Facebook")
            }else{
                if resulte!.isCancelled {
                    self.loadingView.loadingView.stopAnimating()
                }
                guard  let acccestokenString = AccessToken.current?.tokenString else {return}
                let creadinatial = FacebookAuthProvider.credential(withAccessToken: acccestokenString)
                Auth.auth().signIn(with: creadinatial) { (authresult, error) in
                    if error != nil{
                        self.showAlert(title: "using Facebook", message: "error in Login With Facebook")
                    }else{
                        guard let userData = authresult?.user else{return}
                        guard let photoUrl = userData.photoURL?.absoluteString else {return}
                        self.dp.collection(User.user).document(userData.uid).setData(["userName" : userData.displayName ?? "" , "email" : userData.email ?? "", "profileImg" : photoUrl, "DOB": Date().timeIntervalSince1970 ,"uid" : userData.uid] ){ (er) in
                            if er == nil {
                                let home = HomeViewController()
                                let navigation = UINavigationController(rootViewController: home)
                                navigation.modalPresentationStyle = .overFullScreen
                                self.present(navigation, animated: true, completion: nil)
                                UtilityFunctions.isLoggedIn = true
                                
                            }else{
                                self.loadingView.loadingView.stopAnimating()
                                self.showAlert(title: "error in SignIn", message: er?.localizedDescription ?? "unKonw error")
                            }
                           
                            
                            
                        }
                    }
                }
                
            }
        }
        
    }
    
    @IBAction func signInWithGooogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        loadingView.loadingView.startAnimating()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in wit GOOGLE before or they have since signed out.")
            } else {
                self.loadingView.loadingView.stopAnimating()
                print("\(error.localizedDescription)")
            }
            return
        }
        
        
        guard let authentication = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("firebasee sin in error")
                print(error)
                return
            }else{
                guard let imageUrl = user.profile.imageURL(withDimension: .min),let data = try? Data(contentsOf: imageUrl) else{return}
                guard let authUser = authResult else {return}
                self.dp.collection(User.user).document(authUser.user.uid).setData(["userName" : user.profile.name ?? " " , "email" : user.profile.email ?? "", "DOB": Date().timeIntervalSince1970 , "uid" : authUser.user.uid ]  ){ (er) in
                    if er == nil{
                        UserRepositoryManger.uploadImage(userUid: user.userID, Image: data) { (error, secsess) in
                            if secsess{
                               let home = HomeViewController()
                                let navigation = UINavigationController(rootViewController: home)
                                navigation.modalPresentationStyle = .overFullScreen
                                self.present(navigation, animated: true, completion: nil)
                                UtilityFunctions.isLoggedIn = true
                            }else{
                                self.loadingView.loadingView.stopAnimating()
                                guard let err = error else {return}
                                self.showAlert(title: "error in SignIn", message: err)
                            }
                        }
                    }else{
                        self.loadingView.loadingView.stopAnimating()
                        guard let err = er else {return}
                        self.showAlert(title: "error in SignIn", message: err.localizedDescription)
                    }
                    
                }
                
            }
        }
    }
    
    
    @IBAction func signInWithE_mail(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignUp")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
}
