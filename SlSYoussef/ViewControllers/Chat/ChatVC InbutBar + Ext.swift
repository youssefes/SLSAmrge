//
//  ChatVC InbutBar + Ext.swift
//  SlSYoussef
//
//  Created by Hady Helal on 23/03/2021.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import CodableFirebase

//MARK: - ChatVC Extension to InbutBarAccessory
extension ChatVC : InputBarAccessoryViewDelegate {
    
    @objc func attatchImgClicked(){
        handleUploadImage()
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageInputBar.inputTextView.layer.borderWidth = 0.4
        messageInputBar.inputTextView.layer.cornerRadius = 10
        
        //messageInputBar.leftStackView.removeFromSuperview()
        let attachImg = UIButton.init(type: .custom)
        messageInputBar.addSubview(attachImg)
        attachImg.addTarget(self, action: #selector(attatchImgClicked), for: .touchUpInside)
        #warning("Add this assests image")
        attachImg.setBackgroundImage(UIImage(named: "icons8-xlarge_icons"), for: .normal)
        attachImg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            attachImg.topAnchor.constraint(equalTo: messageInputBar.middleContentView!.topAnchor),
            attachImg.trailingAnchor.constraint(equalTo: messageInputBar.middleContentView!.leadingAnchor, constant: -8),
            attachImg.heightAnchor.constraint(equalToConstant: 35),
            attachImg.widthAnchor.constraint(equalToConstant: 35)
            
        ])
        
        for constraint in messageInputBar.leftStackView.constraints {
            messageInputBar.leftStackView.removeConstraint(constraint)

        }

        messageInputBar.middleContentView?.leadingAnchor.constraint(equalTo: messageInputBar.leftStackView.trailingAnchor, constant: 40).isActive = true
        #warning("Add this assests image")
        messageInputBar.sendButton.setImage(UIImage(named: "send-message-icon"), for: .normal)
        //messageInputBar.sendButton.setBackgroundImage(UIImage(named: "send-message-icon"), for: .normal)
        messageInputBar.sendButton.setTitle(nil, for: .normal)
        messageInputBar.inputTextView.placeholderLabel.text = "   Write a message..."
        //        messageInputBar.inputTextView.
        messageInputBar.translatesAutoresizingMaskIntoConstraints = false
        messageInputBar.sendButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @objc func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
        
    }
    
    func setChatAccessToTrue(){
        
    }
    
    func updateChatAccess(){
        //NEW MODIFICATIONS
        let chatAccessVar = [ "\(currentlyUserUid!)" : true, "\(otherUserID!)" : true]
        let dic = ["ChatAccess" : chatAccessVar]
        db.collection("chatChannels").document(channelID!).setData(dic as [String : Any] , merge: true) { (error) in
            guard error == nil else {
                print(error!) ; return
            }
        }
    }
    
    func insertMessage(_ component : [Any]) {
        for component in component {
            // If the message is a simble text
            if let str = component as? String , channelID != nil{
                let model = MessageFB(text: str, recipientID: otherUserID, senderID:  currentUser!.uid!, senderImage: currentUser!.photoURL!.absoluteString , reciverImage:  otherUser![User.profilePic]! as! String , senderName:  currentUser!.displayName!, time: Date(), seen: false)
                
                let docData = try! FirestoreEncoder().encode(model)
                self.messages.append(Message(sender: self.currentUserMsg, messageId: UUID().uuidString, sentDate: Date(), kind: .text(str) ))
                updateCollectionView()
                db.collection("chatChannels").document(channelID!).collection("messages").document().setData(docData , merge: true) {
                    error in
                    guard error == nil else {
                        self.showAlert(title: "Error", message: error!.localizedDescription) ; return
                    }
                    self.updateChatAccess()
                }
                
                
            }else if let img = component as? UIImage , channelID != nil {
                let imgMediaItem = ImageMediaItem(image: img)
                self.messages.append(Message(sender: self.currentUserMsg, messageId: UUID().uuidString, sentDate: Date(), kind: .photo(imgMediaItem) ))
                updateCollectionView()
                
                guard let imgData = img.jpegData(compressionQuality: 0.7) else {
                    self.showAlert(title: "Error", message: "Error in image file try another image")
                    return
                }
                
                ChatVCvm.uploadImgMessage(image: imgData, channelID: channelID!) { (imgURL , error) in
                    guard error == nil else {return}
                    if let imgURL = imgURL {
//                        print("This is the image URL: \(imgURL)")
//                        print("done uploading , now saving reference")
                        let model = MessageFB(imgURL: imgURL, recipientID: self.otherUserID!, senderID: self.currentUser!.uid!, senderImage: self.currentUser!.photoURL!.absoluteString, reciverImage: self.otherUser![User.profilePic]! as! String, senderName: self.currentUser!.displayName!, time: Date(), seen: false )
                                                
                        let docData = try! FirestoreEncoder().encode(model)
                        self.db.collection("chatChannels").document(self.channelID!).collection("messages").document().setData(docData) { (error) in
                            guard error == nil else {
                                self.showAlert(title: "Error", message: error!.localizedDescription) ; return
                            }
                            self.updateChatAccess()
                        }
                    } else {
                        self.showAlert(title: "Error", message: "Maybe the image resource is corrupted try again next time.")
                    }
                }
                
            } else {print("ChannelID may be nil")}
        }
    }
    
    func updateCollectionView(){
        self.messagesCollectionView.performBatchUpdates({
            self.messagesCollectionView.insertSections([self.messages.count - 1])
            if self.messages.count >= 2 {
                self.messagesCollectionView.reloadSections([self.messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
         //Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        messageInputBar.inputTextView.placeholderLabel.text = "   Write a message"
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholderLabel.text = "   Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                    self?.insertMessage(components)
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholderLabel.text = "   Write a message"
                //self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
}
