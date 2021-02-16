//
//  HomeViewModel.swift
//  SlSYoussef
//
//  Created by youssef on 2/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import Firebase

class HomeViewModel{
    
    
    private var collectionOfFireStor : CollectionReference!
    func viewDidLoad(){
        collectionOfFireStor = Firestore.firestore().collection("posts")
    }
    func getPosts(complation : @escaping (_ posts : [PostModel]?, _ error : Error?)-> Void){
        collectionOfFireStor.getDocuments { (QuerySnapshot, error) in
            if error == nil{
                guard let snapshots = QuerySnapshot else {return}
                var arrayofPosts : [PostModel] = []
                for document in snapshots.documents {
                    
                    let data = document.data()
                    let context = data["context"] as? [String : Any]
                    let images = context?["img"] as? [String]
                    let PostText = context?["text"] as? String
                    let userId = data["user"] as? String ?? "no user"
                    let id = document.documentID
                    
                    let secondsFrom1970 = data["date"] as? Double ?? 0
                    print(secondsFrom1970)
                    let  date = Date(timeIntervalSince1970: secondsFrom1970)
                    print(date)
                    let contextPost = Postcontext(image: images, text: PostText)
                    let postData = PostModel(id: id, postContext: contextPost, date: date, userId: userId)
                    arrayofPosts.append(postData)
                }
                complation(arrayofPosts, nil)
            }else{
                complation(nil,error)
            }
        }
    }
    
    
}
