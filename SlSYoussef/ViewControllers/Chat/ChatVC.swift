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
    
    let currentUser = Sender(senderId: "Self", displayName: "Current User")
    
    let otherUser = Sender(senderId: "Other", displayName: "Other User")
    
    var messages = [MessageType] ()
    
    var userToChatId : String!
    
    let dp = Firestore.firestore()
    
    var currentlyUserUid : String?
    
    func currentUserIsValid() -> Bool {
        var isOnline = true
        currentlyUserUid = Auth.auth().currentUser?.uid
        if currentlyUserUid != nil {
            isOnline = true
            print(currentlyUserUid!)
        }else {isOnline = false}
        return isOnline
    }
    
    let otherUserID = "uanV18ZjMLPegT2zUwSlibejdTy1"
    func cc(){
        if currentUserIsValid(){
            let refToCurrentUser = dp.collection(User.user).document(currentlyUserUid!).collection("engagedChatChannels").document(otherUserID)
            let channelID = dp.collection("chatChannels").document().documentID
            
            refToCurrentUser.setData(["channelId" : "\(channelID)"]) { (error) in
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
            }
            
            let refToOtherUser = dp.collection(User.user).document(otherUserID).collection("engagedChatChannels").document(currentlyUserUid!)
            refToOtherUser.setData(["channeId" : channelID]) { (error) in
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
            dp.collection(User.user).document(otherUserID).getDocument { (docSnapshot, error) in
                if error == nil {
                    if let document = docSnapshot , document.exists {
                        if let documentData = document.data(){
                            userName = documentData["username"] as? String
                            userIcon = documentData["profileImg"] as? String
                            if let er = ChatVCvm.saveUserImgAndName(userName: userName, userIcon: userIcon, refToCurrentUser: refToCurrentUser) {
                                self.showAlert(title: "Error", message: er.localizedDescription)
                            }
                        }
                    }
                }else { print(error!.localizedDescription) }
            }
        }else {
            print("=============NOt valid===============")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        creatNavigationBarButtons()
        ChatVCvm.setTheTopMessageView(view: view, MC: messagesCollectionView)
        configureCollectionView()
        configureMessageInputBar()
        cc()
        tapGestureKeyboard()
        messages.append(Message(sender: currentUser,
                                messageId: "2",
                                sentDate: Date().addingTimeInterval(-80000),
                                kind: .text("whassup")))
        messages.append(Message(sender: otherUser,
                                messageId: "3",
                                sentDate: Date().addingTimeInterval(-70000),
                                kind: .text("here si along reply here si along replyhere si along replyhere si along reply here si along reply here si along reply here si along reply here si along reply")))
        messages.append(Message(sender: currentUser,
                                messageId: "4",
                                sentDate: Date().addingTimeInterval(-50000),
                                kind: .text("it works")))
        messages.append(Message(sender: otherUser,
                                messageId: "5",
                                sentDate: Date().addingTimeInterval(-23160),
                                kind: .text("i love apps")))
        
        messages.append(Message(sender: currentUser,
                                messageId: "8794",
                                sentDate: Date().addingTimeInterval(-10165),
                                kind: .text("Hbye basjkl;aslkjg; alkdfgjw")))
        messages.append(Message(sender: currentUser,
                                messageId: "9/8451",
                                sentDate: Date().addingTimeInterval(-10165),
                                kind: .text("Hbye basjkl;aslkjg; alkdfgjw")))
        
    }
    
    func currentSender() -> SenderType {
        return currentUser
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
            
            
        }else if messages[indexPath.section].sender.senderId == currentUser.senderId {
            avatarView.isHidden = false
            avatarView.image = UIImage(named: "hady")
            
        }
        else if messages[indexPath.section].sender.senderId == otherUser.senderId {
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
        if messages[indexPath.section].sender.senderId == currentUser.senderId {
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
        print("==================================")
        let inputBar = messageInputBar.inputTextView
        inputBar.resignFirstResponder()
        
    }
}

extension ChatVC : InputBarAccessoryViewDelegate {
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageInputBar.inputTextView.layer.borderWidth = 0.4
        messageInputBar.inputTextView.layer.cornerRadius = 10
        //        let img = UIImageView(image: UIImage(named: "hady"))
        //        img.translatesAutoresizingMaskIntoConstraints = false
        //        img.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //        img.widthAnchor.constraint(equalToConstant: 60).isActive = true
        //        messageInputBar.leftStackView.addArrangedSubview(img)
        //
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
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                self.messages.append(Message(sender: currentUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text(str)))
            }
        }
    }
    
    func insertMessage(_ component : [Any]) {
        for component in component {
            if let str = component as? String {
                self.messages.append(Message(sender: currentUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text(str)))
                
                // Reload last section to update header/footer labels and insert a new one
                messagesCollectionView.performBatchUpdates({
                    messagesCollectionView.insertSections([messages.count - 1])
                    if messages.count >= 2 {
                        messagesCollectionView.reloadSections([messages.count - 2])
                    }
                }, completion: { [weak self] _ in
                    if self?.isLastSectionVisible() == true {
                        self?.messagesCollectionView.scrollToLastItem(animated: true)
                    }
                })
            }
        }
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

extension MessageContentCell {
    open override func awakeFromNib() {
        super.awakeFromNib()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        label.text = "654"
        label.textColor = .blue
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor , constant: 5),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
}
