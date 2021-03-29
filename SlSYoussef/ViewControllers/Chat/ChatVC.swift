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
    var currentlyUserUid : String?
    var currentUser : UserDataModel?
    var otherUser : [String : Any]!
    var channelID : String?
    var listener : ListenerRegistration?
    var anotherTimeEnteringChat = false
    var nowTime = Date()
    var currentUserMsg : SenderType {
        return  Sender(senderId: currentlyUserUid!, displayName: currentUser!.displayName!)
    }
    
    var otherUserMsg : SenderType {
        return  Sender(senderId: otherUserID, displayName: otherUser[User.userName] as! String)
    }
    
    func retrieveMessages(){
        db.collection(User.user).document(currentlyUserUid!).collection("engagedChatChannels").document(otherUserID).getDocument { (snapshot, error) in
            if error == nil , let _ = snapshot?.exists , let document = snapshot?.data(){
                
                guard let chnlID = document["channelId"] as? String else { print("nooooooooooooooo") ;return }
                self.channelID = chnlID
                self.db.collection("chatChannels").document(self.channelID!).collection("messages").order(by: "time", descending: false).getDocuments  { (snapshot, error) in
                    if error == nil , snapshot != nil {
                        print(snapshot!.count)
                        for document in snapshot!.documents {
                            let docData = document.data()
                            if docData["senderID"] as? String == self.currentUser!.uid {
                                print("\(docData["senderID"] ?? "nillawy")")
                                //print(docData)
                                self.retrieveCurrentUserMessage(data: docData, document: document)
                            }else{
                                self.retrieveOtherMessage(data: docData, document: document)
                            }
                        }
                        
                    }
                    self.messagesCollectionView.reloadData()
                    self.listenForNewMessages(stopListen: false)
                    self.anotherTimeEnteringChat = true
                }
            }

            else {
                self.instantiateChatMessages()
            }
        }
        
    }
     
    func trans(data : [String : Any]) -> Date? {
        guard let stamp = data["time"] as? Timestamp else {
            return nil
        }
        return stamp.dateValue()
    }
    
    func retrieveCurrentUserMessage( data : [String : Any] , document : QueryDocumentSnapshot) {
        if data["type"] as! String == "text" {
            let messageText = data["text"] as! String
            guard let date  = trans(data: data) else {
                self.showAlert(title: "Error", message: "Error in message time propaply time zone is wrong")
                return
            }

            print(messageText)
            messages.append(Message(sender: currentUserMsg , messageId: document.documentID , sentDate: date , kind: .text( messageText) )) }
        else {
            guard let url = data["imgUrl"] as? String else {
                self.showAlert(title: "Error", message: "There is an error in the database")
                return
            }
            
            DispatchQueue.main.async {
                self.DownloadImage(url: url) { (img) in
                    let image = ImageMediaItem(image: img)
                    self.messages.append(Message(sender: self.currentUserMsg , messageId: document.documentID , sentDate: data["time"] as! Date, kind: .photo(image) ))
                }
            }
        }
        messagesCollectionView.reloadData()
    }
    
    func retrieveOtherMessage(data : [String : Any], document : QueryDocumentSnapshot){
        if data["type"] as! String == "text" {
            let messageText = data["text"] as! String
            guard let date  = trans(data: data) else {
                self.showAlert(title: "Error", message: "Error in message time propaply time zone is wrong")
                return
            }
            messages.append(Message(sender: otherUserMsg , messageId: document.documentID , sentDate: date,
                                    kind: .text( messageText ) )) }
        else {
            guard let url = data["imgUrl"] as? String else {
                self.showAlert(title: "Error", message: "There is an error in the database")
                return
            }
            
            DispatchQueue.main.async {
                self.DownloadImage(url: url) { (img) in
                    let image = ImageMediaItem(image: img)
                    guard let date  = self.trans(data: data) else { return}
                    self.messages.append(Message(sender: self.otherUserMsg , messageId: document.documentID , sentDate: date,
                                                 kind: .photo(image) ))
                    self.messagesCollectionView.reloadData()
                }
            }
        
        }
        messagesCollectionView.reloadData()
        
    }
    
    func handle (_ result : Result<RetrieveImageResult,KingfisherError>) -> Bool{
        var status : Bool
        switch result {
        case .success(let retrievedImage):
            status = true
            let image = retrievedImage.image
            let casheType = retrievedImage.cacheType
            let source = retrievedImage.source
            let originalResource = retrievedImage.originalSource
            let message = """
            ImageSize:
            \(image.size)
            
            cashe:
            \(casheType)
            
            source:
            \(source)

            Original source:
            \(originalResource)
             
            """
            self.showAlert(title: "Success!", message: message)
            return true
        case .failure(let error):
            status = false
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
        return status
    }
    
    func DownloadImage(url : String , completed : @escaping (_ image : UIImage) ->Void){
        let resource = ImageResource(downloadURL: URL(string: url)!)
        let placeholder = UIImage(named: "face")
        let processor = RoundCornerImageProcessor(cornerRadius: 20.0)
        let img = UIImageView()
        img.kf.indicatorType = .activity
        img.kf.setImage(with: resource, placeholder: placeholder, options: [.processor(processor)]) { (receivedSize, totalSize) in
            let precentage = (Float(receivedSize) / Float(totalSize)) + 100
            print("Downloading progress \(precentage)%")
            
        } completionHandler: { [self] (result) in
            if self.handle(result) {
                completed(img.image!)
            }
        }
    }
    
    
    func listenForNewMessages(stopListen : Bool){
        if !stopListen {
            listener = db.collection("chatChannels").document(channelID!).collection("messages").order(by: "time", descending: false).addSnapshotListener { (snapShot, error) in
                if error == nil {
                    guard let documents = snapShot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    let newMsg = documents.last!.data()
                    guard let transTime = self.trans(data: newMsg)  , transTime > self.nowTime else {
                        return
                    }
                    print("Current new msg is : \(newMsg)")
                    if newMsg["senderID"] as? String == self.currentUser!.uid {
                        self.retrieveCurrentUserMessage(data: newMsg, document: documents.last!)
                    }else{
                            self.retrieveOtherMessage(data: newMsg, document: documents.last!)
                        }
                    
                    
                }
            }
        } else {
            if let listener = listener { listener.remove()}
        }
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
            print("55555555556")
            return
        }
        
        currentlyUserUid = user.uid!
        self.currentUser = user

        creatNavigationBarButtons()
        ChatVCvm.setTheTopMessageView(view: view, MC: messagesCollectionView)
        configureCollectionView()
        configureMessageInputBar()
        tapGestureKeyboard()
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
            
            //create userInfo map and add ( userIcon , userName )
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
