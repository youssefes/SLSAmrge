//
//  ChatVC + RetrieveMessages.swift
//  SlSYoussef
//
//  Created by Hady Helal on 05/04/2021.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Firebase

extension ChatVC{
   
    //MARK: - Retrieve Messages
    func retrieveMessages(){
        db.collection(User.user).document(currentlyUserUid!).collection("engagedChatChannels").document(otherUserID).getDocument { (snapshot, error) in
            if error == nil , let _ = snapshot?.exists , let document = snapshot?.data(){
                
                guard let chnlID = document["channelId"] as? String else { return }
                self.channelID = chnlID
                self.db.collection("chatChannels").document(self.channelID!).collection("messages").order(by: "time", descending: false).getDocuments  { (snapshot, error) in
                    if error == nil , snapshot != nil {
                        for document in snapshot!.documents {
                            let docData = document.data()
                            if docData["senderID"] as? String == self.currentUser!.uid {
                                self.retrieveCurrentUserMessage(data: docData, document: document)
                            }else{
                                self.retrieveOtherMessage(data: docData, document: document)
                            }
                        }
                        
                    }
                    self.messagesCollectionView.reloadData()
                    self.listenForNewMessages(stopListen: false)
                }
            }
            
            else {
                self.instantiateChatMessages()
            }
        }
    }
    
    //MARK: - Retrieve Current User Messages
    func retrieveCurrentUserMessage( data : [String : Any] , document : QueryDocumentSnapshot) {
        if data["type"] as! String == "text" {
            let messageText = data["text"] as! String
            guard let date  = ImagesOperations.trans(data: data) else {
                self.showAlert(title: "Error", message: "Error in message time propaply time zone is wrong")
                return
            }

            //print(messageText)
            messages.append(Message(sender: currentUserMsg , messageId: document.documentID , sentDate: date , kind: .text( messageText) )) }
        else {
            guard let url = data["imgUrl"] as? String else {
                self.showAlert(title: "Error", message: "There is an error in the database")
                return
            }
            
            self.DownloadImage(url: url) { (img) in
                guard let img = img else {
                    self.showAlert(title: "Error", message: "Error downloading images please check your internet connection and try again")
                    return
                }
                let image = ImageMediaItem(image: img)
                var msgInserted = false
                guard let date  = ImagesOperations.trans(data: data) else { return}
                var idx = 0
                let msg = Message(sender: self.currentUserMsg , messageId: document.documentID , sentDate: date, kind: .photo(image) )
                for msg in self.messages {
                    if msg.sentDate > date {
                        self.messages.insert( msg , at: idx)
                        msgInserted = true
                        break
                    }
                    idx += 1
                }
                if !msgInserted {self.messages.append(msg) }
            }
            
        }
        messagesCollectionView.reloadData()
    }
    
    //MARK: - Retrieve Other user Messages
    func retrieveOtherMessage(data : [String : Any], document : QueryDocumentSnapshot){
        
        if data["type"] as! String == "text" {
            let messageText = data["text"] as! String
            guard let date  = ImagesOperations.trans(data: data) else {
                self.showAlert(title: "Error", message: "Error in message time propaply time zone is wrong")
                return
            }
            messages.append(Message(sender: otherUserMsg , messageId: document.documentID , sentDate: date,
                                    kind: .text( messageText ) ))
            self.setMessageToSeenStatus(document: document)
        }
        
        else {
            guard let url = data["imgUrl"] as? String else {
                self.showAlert(title: "Error", message: "There is an error in the database image")
                return
            }
            
            self.DownloadImage(url: url) { (img) in
                guard let img = img else {
                    self.showAlert(title: "Error", message: "Error downloading images please check your internet connection and try again")
                    return
                }
                let image = ImageMediaItem(image: img)
                var msgInserted = false
                guard let date  = ImagesOperations.trans(data: data) else { return}
                var idx = 0
                let message = Message(sender: self.otherUserMsg , messageId: document.documentID , sentDate: date, kind: .photo(image) )
                for msg in self.messages {
                    if msg.sentDate > date {
                        self.messages.insert(message, at: idx)
                        self.db.collection("chatChannels").document(self.channelID!).collection("messages").document(document.documentID).setData(["seen" : true], merge: true)
                        msgInserted = true
                        break
                    }
                    idx += 1
                }
                if !msgInserted {
                    self.messages.append(message)
                    self.setMessageToSeenStatus(document: document)
                }
                self.messagesCollectionView.reloadData()
            }
        }
        messagesCollectionView.reloadData()
        
    }
    
    func setMessageToSeenStatus(document : QueryDocumentSnapshot){
        self.db.collection("chatChannels").document(self.channelID!).collection("messages").document(document.documentID).setData(["seen" : true], merge: true)
    }
}
