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
import Kingfisher

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
    let db = Firestore.firestore()
    var messages = [MessageType] ()
    var otherUserID : String!
    var otherUserImage : UIImage?
    var otherUser : [String : Any]!
    
    var currentlyUserUid : String?
    var currentUser : UserDataModel?
    var currentUserImg : UIImage?

    var channelID : String?
    var listener : ListenerRegistration?
    var nowTime = Date()

    var currentUserMsg : SenderType {
        return  Sender(senderId: currentlyUserUid!, displayName: currentUser!.displayName!)
    }
    
    var otherUserMsg : SenderType {
        return  Sender(senderId: otherUserID, displayName: otherUser[User.userName] as! String)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieveMessages()
        nowTime = Date()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let listener = self.listener { listener.remove()}
        
        messages.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = UtilityFunctions.user else {
            return
        }
        
        currentlyUserUid = user.uid!
        self.currentUser = user
        
        creatNavigationBarButtons()
        ChatVCvm.setTheTopMessageView(view: view, MC: messagesCollectionView, img: otherUserImage ?? UIImage(named: "ppp")! , otherUserName: otherUser["userName"] as! String, isOnline: otherUser["isOnline"] as! Bool)
        configureCollectionView()
        configureMessageInputBar()
        tapGestureKeyboard()
        //Downloading current user image and set it in the message cell
        if let imgURL = currentUser?.photoURL {
            DownloadImage(url: imgURL.absoluteString) { (image) in
                if let image = image {
                    self.currentUserImg = image
                    self.messagesCollectionView.reloadData() }
            }
        }
        
        
    }
    
    func instantiateChatMessages(){
        if UtilityFunctions.isLoggedIn {
            let (refToCurrentUser ,channelID , refError) = ChatVCvm.refToCurrent(currentlyUserUid: currentlyUserUid, otherUserID: otherUserID , dp: db)
            self.channelID = channelID
            
            guard refError == nil else {
                self.showAlert(title: "Error", message: refError!.localizedDescription)
                return
            }
            
            guard ChatVCvm.refToOther(currentlyUserUid: currentlyUserUid!, otherUserID: otherUserID, channelID: channelID, dp: db) == nil else {
                self.showAlert(title: "Error", message: "Uh there is an error intializing the chat please try again later!")
                return
            }
            
            db.collection("chatChannels").document(channelID).setData(["userIds" : [currentlyUserUid! , otherUserID]]) { (error) in
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
            }
            
            var userIcon : String?
            var userName : String?
            ChatVCvm.getUserDocumentData(uid: otherUserID, dp: db){ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    userName = data["userName"] as? String
                    userIcon = data["profileImg"] as? String
                    if let er = ChatVCvm.saveUserImgAndName(userName: userName, userIcon: userIcon, refToCurrentUser: refToCurrentUser as! DocumentReference) {
                        self.showAlert(title: "Error", message: er.localizedDescription)
                    }
                    
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }else {
            dismiss(animated: true, completion: nil)
        }
    }

    func listenForNewMessages(stopListen : Bool){
        listener = db.collection("chatChannels").document(channelID!).collection("messages").order(by: "time", descending: true).addSnapshotListener { (snapShot, error) in
            if error == nil {
                guard let documents = snapShot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                 
                for document in documents {
                    let newMsg = document.data()

                    if newMsg["senderID"] as? String == self.currentUser!.uid  {
                        continue
                    }
                    
                    if let transTime = ImagesOperations.trans(data: newMsg)  , transTime < self.nowTime  {
                        continue
                    }
                    self.retrieveOtherMessage(data: newMsg, document: documents.last!)
                }
                self.nowTime = Date()
                self.scrollToLastItemInLastSection()
            }
        }
        

    }
    
    //Before using this funciton make sure that messagecollection view have more than one seciton
    func scrollToLastItemInLastSection(){
        let lastSection = self.messagesCollectionView.numberOfSections - 1

        let lastRow = self.messagesCollectionView.numberOfItems(inSection: lastSection)

        let indexPath = IndexPath(row: lastRow - 1, section: lastSection)

        self.messagesCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)

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
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if messages[indexPath.section] is UIImage {
            print("image at \(messages[indexPath.section].kind)")
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if indexPath.section >= 1 , messages[indexPath.section - 1].sender.senderId == messages[indexPath.section].sender.senderId {
            avatarView.isHidden = true
            
        }else if messages[indexPath.section].sender.senderId == currentUserMsg.senderId {
            avatarView.isHidden = false
            avatarView.image = currentUserImg ?? nil
            #warning("Here set the current user picture")
            
        }
        else if messages[indexPath.section].sender.senderId == otherUserMsg.senderId {
            avatarView.image = otherUserImage ?? UIImage()
            #warning("set the default image")
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
        maintainPositionOnKeyboardFrameChanged   = true // default false
        
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

extension ChatVC : MessagesLayoutDelegate , MessagesDisplayDelegate  {}
extension ChatVC : MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        print("Image tapedk")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("message tapped")
    }
}
