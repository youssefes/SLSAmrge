//
//  ChatVCvm.swift
//  SlSYoussef
//
//  Created by Hady on 2/18/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
import CodableFirebase
class ChatVCvm {
    
    static func setTheTopMessageView(view : UIView , MC : MessagesCollectionView) {
        let subView = TopMessageView()
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
        
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            subView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            subView.heightAnchor.constraint(equalToConstant: 100)
        ])
        subView.backgroundColor = .white
        MC.contentInset.top = 70 + 64
        
    }
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static func saveUserImgAndName(userName : String? , userIcon : String? , refToCurrentUser : DocumentReference) -> Error?{
        var isValidFunc : Error?
        let otherUserInfo = [ "userName" : userName! , "userIcon" : userIcon!]
        let dic = ["userInfo" : otherUserInfo]
        refToCurrentUser.setData(dic as [String : Any] , merge: true) { (error) in
            if error != nil {
                isValidFunc =  error
            }
            
            print("This is the fetched document")
            print(dic)
        }
        return isValidFunc
    }
    
    static func getUserDocumentData(uid : String , dp : Firestore ,completed : @escaping (Result<[String : Any] , Er>) -> Void){
        dp.collection(User.user).document(uid).getDocument { (documentSnapShot, error) in
            var err : Er = Er(error: error, userNotExist: false)
            if error == nil {
                if let document = documentSnapShot , document.exists {
                    if let documentData = document.data(){
                        completed(.success(documentData))
                    }
                } else {
                    err.userNotExist = true
                    completed(.failure(err))}
            }else {completed(.failure(err))}
        }
    }
    
    struct Er : Error {
        var error : Error?
        var userNotExist : Bool
    }
    
    
    static func refToCurrent(currentlyUserUid : String?, otherUserID : String , dp : Firestore) -> (Any , String ,Error?){
        var er : Error?
        let refToCurrentUser = dp.collection(User.user).document(currentlyUserUid!).collection("engagedChatChannels").document(otherUserID)
        let channelID = dp.collection("chatChannels").document().documentID
        
        refToCurrentUser.setData(["channelId" : "\(channelID)"] ,merge: true) { (error) in
            er = error
        }
        
        return (refToCurrentUser ,channelID , er)
    }
    
    static func refToOther(currentlyUserUid : String , otherUserID : String , channelID : String , dp : Firestore) -> Error?{
        var er : Error?
        let refToOtherUser = dp.collection(User.user).document(otherUserID).collection("engagedChatChannels").document(currentlyUserUid)
        refToOtherUser.setData(["channelId" : channelID] , merge: true) { (error) in
            if error != nil {
                er = error
            }
        }
        return er
    }
    
    static func uploadImgMessage(image : Data , channelID : String , compltion : @escaping (_ imgURl : String? , _ error : Error?) -> Void){
        var er : Error?
        let imageName = UUID().uuidString
        let imgReference = Storage.storage().reference().child("Messages").child(channelID).child(imageName)
        // group.enter()
        imgReference.putData(image, metadata: nil) { (metaData, error) in
            if let err = error {
                er = err
            }else{
                imgReference.downloadURL { (url, error) in
                    if let error = error {
                        er = error
                    }else {
                        print("The picture uploaded and now we downloaded the URL")
                    }
                    
                    guard let url = url else {
                        return
                    }
                    
                    compltion(url.absoluteString , er)
                }
                
            }
            
        }

    }
    
}
