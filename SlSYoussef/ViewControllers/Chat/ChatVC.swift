//
//  ChatVC.swift
//  SLS
//
//  Created by Hady on 1/26/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import CodableFirebase

struct Sender : SenderType {
    var senderId: String
    
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}

class ChatVC: MessagesViewController , MessagesDataSource {
    
    //MARK: - Get users data
    let dp = Firestore.firestore()

    var messages = [MessageType] ()
    var otherUserID : String!
    var currentlyUserUid : String?
    var currentUser : UserDataModel?
    var otherUser : [String : Any]!
    var channelID : String?
    
    var currentUserMsg : SenderType {
        return  Sender(senderId: currentlyUserUid!, displayName: currentUser!.displayName!)
    }
    
    var otherUserMsg : SenderType {
        return  Sender(senderId: otherUserID, displayName: otherUser[User.userName] as! String)
    }

    func retrieveMessages(){
        dp.collection("chatChannels").document(channelID!).collection("messages").getDocuments { (snapshot, error) in
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
        }
        
    }
    
    func retrieveCurrentUserMessage( data : [String : Any] , document : QueryDocumentSnapshot) {
        if data["type"] as! String == "text" {
            messages.append(Message(sender: currentUserMsg , messageId: document.documentID , sentDate: data["time"] as! Date,
                                    kind: .text( data["text"] as! String ) )) }
        else {
            let image = ImageMediaItem(image: UIImage(named: "hady")!)
            messages.append(Message(sender: currentUserMsg , messageId: document.documentID , sentDate: data["time"] as! Date,
                                    kind: .photo(image) ))
        }
    }
    
    func retrieveOtherMessage(data : [String : Any], document : QueryDocumentSnapshot){
        if data["type"] as! String == "text" {
            messages.append(Message(sender: otherUserMsg , messageId: document.documentID , sentDate: data["time"] as! Date,
                                    kind: .text( data["text"] as! String ) )) }
        else {
            let image = ImageMediaItem(image: UIImage(named: "hady")!)
            messages.append(Message(sender: otherUserMsg , messageId: document.documentID , sentDate: data["time"] as! Date,
                                    kind: .photo(image) ))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = UtilityFunctions.user else {
            print("55555555556")
            return
        }
        currentlyUserUid = user.uid!
        self.currentUser = user
        instantiateChatMessages()

        creatNavigationBarButtons()
        ChatVCvm.setTheTopMessageView(view: view, MC: messagesCollectionView)
        configureCollectionView()
        configureMessageInputBar()
        tapGestureKeyboard()
        
        messages.append(Message(sender: currentUserMsg,
                                messageId: "2",
                                sentDate: Date().addingTimeInterval(-80000),
                                kind: .text("whassup")))
        messages.append(Message(sender: otherUserMsg,
                                messageId: "3",
                                sentDate: Date().addingTimeInterval(-70000),
                                kind: .text("here si along reply here si along replyhere si along replyhere si along reply here si along reply here si along reply here si along reply here si along reply")))
        messages.append(Message(sender: currentUserMsg,
                                messageId: "4",
                                sentDate: Date().addingTimeInterval(-50000),
                                kind: .text("it works")))
        messages.append(Message(sender: otherUserMsg,
                                messageId: "5",
                                sentDate: Date().addingTimeInterval(-23160),
                                kind: .text("i love apps")))
        
    }
    
    func instantiateChatMessages(){
        if UtilityFunctions.isLoggedIn {
            
            let refToCurrentUser = dp.collection(User.user).document(currentlyUserUid!).collection("engagedChatChannels").document(otherUserID)
            let channelID = dp.collection("chatChannels").document().documentID
            self.channelID = channelID
            refToCurrentUser.setData(["channelId" : "\(channelID)"] ,merge: true) { (error) in
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
            }
            
            let refToOtherUser = dp.collection(User.user).document(otherUserID).collection("engagedChatChannels").document(currentlyUserUid!)
            refToOtherUser.setData(["channeId" : channelID] , merge: true) { (error) in
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
            }
            
            dp.collection("chatChannels").document(channelID).setData(["userIds" : [currentlyUserUid! , otherUserID]]) { (error) in
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
            }
            
            //create userInfo map and add ( userIcon , userName )
            var userIcon : String?
            var userName : String?
            ChatVCvm.getUserDocumentData(uid: otherUserID, dp: dp){ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    userName = data["username"] as? String
                    userIcon = data["profileImg"] as? String
                    if let er = ChatVCvm.saveUserImgAndName(userName: userName, userIcon: userIcon, refToCurrentUser: refToCurrentUser) {
                        self.showAlert(title: "Error", message: er.localizedDescription)
                    }
                    
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }else {
            print("=============NOt valid===============")
            
        }
    }

    
    //MARK: - Message Cell Delegate functions
    func currentSender() -> SenderType {
        return currentUserMsg
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if indexPath.section >= 1 , messages[indexPath.section - 1].sender.senderId == messages[indexPath.section].sender.senderId {
            avatarView.isHidden = true
            
        }else if messages[indexPath.section].sender.senderId == currentUserMsg.senderId {
            avatarView.isHidden = false
            avatarView.image = UIImage(named: "hady")
            
        }
        else if messages[indexPath.section].sender.senderId == otherUserMsg.senderId {
            avatarView.image = UIImage(named: "ppp")
            avatarView.isHidden = false
        }
        else {
            avatarView.isHidden = false
        }
        
    }
    
    // MARK: - Private properties
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = ChatVCvm.formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    private func configureCollectionView() {
        messagesCollectionView.messagesDataSource      = self
        messagesCollectionView.messagesLayoutDelegate  = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        //  maintainPositionOnKeyboardFrameChanged   = true // default false
        
        showMessageTimestampOnSwipeLeft = true // default false
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if messages[indexPath.section].sender.senderId == currentUserMsg.senderId {
            return UIColor(red: 254/255, green: 235/255, blue: 253/255, alpha: 1)
        }
        else {
            return UIColor(red: 207/255, green: 235/255, blue: 253/255, alpha: 1)
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor.black
    }
    
    func tapGestureKeyboard(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        messagesCollectionView.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyBoard(){
        let inputBar = messageInputBar.inputTextView
        inputBar.resignFirstResponder()
        
    }
}

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
        attachImg.setBackgroundImage(UIImage(named: "hady"), for: .normal)
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

        //attachImg.bringSubviewToFront(messageInputBar)

        messageInputBar.middleContentView?.leadingAnchor.constraint(equalTo: messageInputBar.leftStackView.trailingAnchor, constant: 40).isActive = true
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
    
    func insertMessage(_ component : [Any]) {
        for component in component {
            if let str = component as? String , channelID != nil{
                let model = MessageFB(text: str, recipientID: otherUserID, senderID:  currentUser!.uid!, senderImage: currentUser!.photoURL!.absoluteString , reciverImage:  otherUser![User.profilePic]! as! String , senderName:  currentUser!.displayName!, time: Date())
                
                let docData = try! FirestoreEncoder().encode(model)
                self.messages.append(Message(sender: self.currentUserMsg, messageId: UUID().uuidString, sentDate: Date(), kind: .text(str) ))
                updateCollectionView()
                dp.collection("c").document(channelID!).collection("messages").document().setData(docData) {
                    error in
                    if error != nil {
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                    }
                    
                }
                
            }else if let img = component as? UIImage , channelID != nil {
                let imgMediaItem = ImageMediaItem(image: img)
                self.messages.append(Message(sender: self.currentUserMsg, messageId: UUID().uuidString, sentDate: Date(), kind: .photo(imgMediaItem) ))
                updateCollectionView()
                
                guard let imgData = img.jpegData(compressionQuality: 1.0) else {
                    self.showAlert(title: "Error", message: "Error in image file try another image")
                    return
                }
                
                guard let imgURL = ChatVCvm.uploadImgMessage(image: imgData, channelID: self.channelID!) else {
                    self.showAlert(title: "Error uploading image", message: "Please check your internet connection")
                    return
                }
                print(imgURL)
                self.showAlert(title: "time", message: "done uploading , now saving reference")
                let model = MessageFB(imgURL: imgURL, recipientID: otherUserID!, senderID: currentUser!.uid!, senderImage: currentUser!.photoURL!.absoluteString, reciverImage: otherUser![User.profilePic]! as! String, senderName: currentUser!.displayName!, time: Date())
                
                print(model)
                
                let docData = try! FirestoreEncoder().encode(model)
                dp.collection("chatChannels").document(channelID!).collection("messages").document().setData(docData) { (error) in
                    if error != nil{
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                    }else {self.showAlert(title: "Success", message: "The image uploaded successfully")}
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
        // Here we can parse for which substrings were autocompleted
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
                //        self?.messagesCollectionView.reloadData()
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholderLabel.text = "   Write a message"
                //self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
}

extension ChatVC : MessagesLayoutDelegate , MessagesDisplayDelegate  {}
