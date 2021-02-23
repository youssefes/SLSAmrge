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
class ChatVCvm {
    
    static func setTheTopMessageView(view : UIView , MC : MessagesCollectionView) {
        let subView = TopMessageView()
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
        
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            subView.topAnchor.constraint(equalTo: view.topAnchor , constant: 5 ),
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
      
    static func getUserDocumentData(uid : String , dp : Firestore ,completed : @escaping (Result<[String : Any] , Error>) -> Void){
        dp.collection(User.user).document(uid).getDocument { (documentSnapShot, error) in
            if error == nil {
                if let document = documentSnapShot , document.exists {
                    if let documentData = document.data(){
                        completed(.success(documentData))
                    }
                }
            }else {completed(.failure(error!))}
        }
    }
    
}