//
//  Messages.swift
//  SlSYoussef
//
//  Created by Hady on 2/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Firebase
class Messages: UIViewController ,UITableViewDelegate , UITableViewDataSource {        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var numberOfMessagesLabel: UILabel!
    var currentlyUserUid        = ""
    var numOfMessages           = 0
    var isMessagesExist         = false
    var emptyStateExisted       = false
    var deleteMsgIndexPath: IndexPath? = nil
    var numberOfNewMessages     =  0
    
    let emptyStateView          = EmptyStateVC()
    let db                      = Firestore.firestore()
    var otherUserID : String?
    var currentUser : UserDataModel?
    var messages = [MessageData] ()
    var originalMessages = [MessageData] ()
    //var ChannelsData : [ChannelData]? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUserMessages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = UtilityFunctions.user else {
            return
        }
        
        currentlyUserUid = user.uid!
        self.currentUser = user
        print(currentUser)
        //        emptyStateExisted = false
        //        emptyStateFunctionality()
        self.showLoadingView()
        creatNavigationBarButtons()
        configureTableView()
//        configureSearchController()
        //navigationController?.hidesBarsOnSwipe = true
        
    }
    
    
    @IBAction func cleanAll(_ sender: Any) {
        db.collection("chatChannels").whereField("ChatAccess.\(currentlyUserUid)", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("================")
                        print(document.data())
                        print("================")
                        print(document.documentID)
                        self.db.collection("chatChannels").document(document.documentID).updateData(["ChatAccess.\(self.currentlyUserUid)" : false]) { [self] (error) in
                            guard error == nil else {
                                self.showAlert(title: "Error deleting chat from database", message: "Maybe there is bad internet connection, please try again later")
                                return
                            }
                            self.numOfMessages = 0
                            self.tableView.reloadData()
                            createEmptyStateView()
                            numberOfNewMessages = 0
                            self.numberOfMessagesLabel.text = "You have \(self.numberOfNewMessages) new Messages"
                        }
                    }
                }
            }
    }
    
    func loadUserMessages(){
        db.collection("chatChannels").whereField("ChatAccess.\(currentlyUserUid)", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                guard err == nil else  {
                    self.hideLoadingView()
                    self.showAlert(title: "Error", message: err!.localizedDescription) ; return
                }

                guard querySnapshot!.count >= 1 else {
                    self.hideLoadingView()
                    self.isMessagesExist  = false
                    self.emptyStateFunctionality()
                    return
                }

                self.hideLoadingView()
                self.isMessagesExist = true
                self.emptyStateFunctionality()
                self.numOfMessages = querySnapshot!.count

                for document in querySnapshot!.documents {
                    let data          = document.data()

                    guard let userIds = data["userIds"] as? Array<String> else {
                        return
                    }

                    for id in userIds {
                        if id != self.currentlyUserUid { self.otherUserID = id ; break }

                    }
                    self.getImageAndName(otherUserID: self.otherUserID, channelID: document.documentID)

                }

            }

        
        
//        db.collection(User.user).document(currentlyUserUid).collection("engagedChatChannels").getDocuments { (snapshots, error) in
//
//            guard let snapshot = snapshots , error == nil else {
//                self.hideLoadingView()
//                self.showAlert(title: "Error", message: "This user has no messages")
//                return
//            }
//
//            self.numOfMessages = snapshot.count
//            //print(self.numOfMessages)
//            guard snapshot.count >= 1 else {
//                self.hideLoadingView()
//                self.isMessagesExist  = false
//                self.emptyStateFunctionality()
//                return
//            }
//            self.hideLoadingView()
//            self.isMessagesExist = true
//            self.emptyStateFunctionality()
//
//            for document in snapshot.documents {
//                let data = document.data()
//                //print(data)
//                guard let chnlID = data["channelId"] as? String else {
//                    //   self.showAlert(title: "Error", message: "Error connecting to our servers")
//                    return
//                }
//
//                //channelId = chnlID
//                self.headingToChannelID(channelID : chnlID)
//
//            }
//        }
        
    }
//
//    func headingToChannelID(channelID : String ) {
//        //Retrieveing last message from current channelID
//        db.collection("chatChannels").document(channelID).getDocument { (snapshot, error) in
//            if error == nil , ((snapshot?.exists) != nil) {
//                guard let data = snapshot?.data() else {
//                    //self.showAlert(title: "Error", message: "Error connecting to our servers chat")
//                    return
//                }
//
//                guard let userIds = data["userIds"] as? Array<String> else {
//                    // self.showAlert(title: "Error", message: "Error connecting to our servers")
//                    print("hena yasta")
//                    return
//                }
//
//                for id in userIds {
//                    if id != self.currentlyUserUid { self.otherUserID = id ; break }
//
//                }
//                self.getImageAndName(otherUserID: self.otherUserID, channelID: channelID)
//
//            }
//        }
//
//    }
    
    func getImageAndName(otherUserID : String? ,channelID : String ){
        if otherUserID != nil {
            db.collection(User.user).document(otherUserID!).getDocument { (snapshot, error) in
                if error == nil , ((snapshot?.exists) != nil) {
                    let data = snapshot?.data()
                    if let data = data {
                        guard let userName = data["userName"] as? String else {
                            return
                        }
                        
                        guard let profileImgUrl = data["profileImg"] as? String else {
                            return
                        }
                        
                        guard let otherUserOnlineState = data["isOnline"] as? Bool else {
                            return
                        }
                        
                        #warning("Set default sender picture into chatCell")
                        #warning("Set online state and handle it's operations")
                        ImagesOperations.DownloadImage(url: profileImgUrl) { (img) in
                            self.retrieveLastMessage(channelID: channelID) { (retrievedMsg)  in
                                
                                guard let correctMsg = retrievedMsg else {
                                    return
                                }
                                
                                let msgData = MessageData(messageTime: correctMsg.msgDate,
                                                          messageBody: correctMsg.messageBody, senderImage: img,
                                                          senderName: userName, senderUID: otherUserID!,
                                                          channelID: channelID, seen: correctMsg.seen, isOnline: otherUserOnlineState)
                                
                                self.messages.append(msgData)
                                
                                if correctMsg.seen == false , msgData.senderUID == otherUserID! {self.numberOfNewMessages += 1}
                                self.numberOfMessagesLabel.text = "You have \(self.numberOfNewMessages) new Messages"
                                
                                print("========----------======")
                                print(self.messages.count)
                                print(msgData)
                                self.tableView.reloadData()
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func retrieveLastMessage(channelID : String , completed : @escaping(_ retrivedMsg : RetrievedData? ) -> Void ){
        db.collection("chatChannels").document(channelID).collection("messages").order(by: "time").getDocuments { (snapshot, error) in
            if error == nil , ((snapshot?.isEmpty) != nil) {
                for document in snapshot!.documents.reversed() {
                    let data = document.data()
                    
                    if let msg  = data["text"] as? String , let date  = ImagesOperations.trans(data: data){
                        if let seen = data["seen"] as? Bool {
                        if let senderUID = data["senderID"] as? String {
                                let msgData = RetrievedData(messageBody: msg, msgDate: date, senderUID: senderUID, seen: seen)
                                completed(msgData)
                                break
                            }
                            
                        }
                        
                    }else if let _ = data["imgUrl"] as? String, let date = ImagesOperations.trans(data: data){
                        if let seen = data["seen"] as? Bool {
                            if let senderUID = data["senderID"] as? String {
                                let msgData = RetrievedData(messageBody: "📷", msgDate: date, senderUID: senderUID, seen: seen)
                                completed(msgData)
                                break
                            }
                        }
                        
                    }
                    else {
                        #warning("This one maybe gonna be deleted")
                        self.showAlert(title: "Error", message: "Error while loading friends messages")
                        completed(nil)
                        break
                    }
                    
                }
            }
        }
    }
    
    func emptyStateFunctionality() {
        if !isMessagesExist , !emptyStateExisted{
            numOfMessages = 0
            emptyStateExisted = true
            createEmptyStateView()
            numberOfNewMessages = 0
        }
        else if isMessagesExist , emptyStateExisted{
            emptyStateView.removeFromSuperview()
            emptyStateExisted = false
            numOfMessages = messages.count
            tableView.reloadData()
        }
    }
    
    func createEmptyStateView(){
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.messageLabel.text                         = "Nothing here"
        
        NSLayoutConstraint.activate([
            emptyStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyStateView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func swipedRightAndUserWantsToDismiss() {
        super.swipedRightAndUserWantsToDismiss()
    }
    
    private func configureTableView(){
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: ChatCell.cellIdentifier)
        //tableView.rowHeight  = UITableView.automaticDimension
        tableView.rowHeight  = 100
        tableView.tableFooterView =  UIView()
        //tableView.separatorStyle = .singleLine
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfMessages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellIdentifier, for: indexPath) as! ChatCell
        
        let weekDay    = messages[indexPath.row].messageTime.dayOfWeek()!
        let currentMsg = messages[indexPath.row]
        
        cell.messageTime.text  = currentMsg.messageTime.getMessageTime(for: currentMsg.messageTime, dayOfWeek: weekDay)
        cell.messageBody.text  = currentMsg.messageBody
        cell.senderImage.image = currentMsg.senderImage
        cell.senderName.text   = currentMsg.senderName
        
        if !currentMsg.seen , currentMsg.senderUID == currentlyUserUid{
            cell.backgroundColor = .systemRed//UIColor(red: 181, green: 242, blue: 240, alpha: 1)
        }
        
        if !currentMsg.isOnline {
            cell.onlineStateImage.image = UIImage()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteMsgIndexPath = indexPath
            let messageToDelete = messages[indexPath.row]
            confirmDelete(selectedMessage: messageToDelete)
        }
    }
    
    func confirmDelete(selectedMessage: MessageData) {
        let alert = UIAlertController(title: "Delete Message", message: "Are you sure you want to permanently delete \(selectedMessage.senderName)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteChat)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteChat)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteChat(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteMsgIndexPath {
            tableView.beginUpdates()
            
            let x = messages[indexPath.row].channelID
            db.collection("chatChannels").document(x).updateData(["ChatAccess.\(currentlyUserUid)" : false]) { (error) in
                guard error == nil else {
                    self.showAlert(title: "Error deleting chat from database", message: "Maybe there is bad internet connection, please try again later")
                    return
                }
                
                self.messages.remove(at: indexPath.row)
                // Note that indexPath is wrapped in an array:  [indexPath]
                self.numOfMessages = self.messages.count
                //    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                //   self.numOfMessages = self.messages.count
                self.deleteMsgIndexPath = nil
                
                self.numberOfNewMessages -= 1
                self.numberOfMessagesLabel.text = "You have \(self.numberOfNewMessages) new Messages"
                
                if self.messages.count == 0 { self.isMessagesExist = false }
                self.emptyStateFunctionality()
            }
            
            tableView.endUpdates()
            
        }else {
            print("nilo")
        }
    }
    
    func cancelDeleteChat(alertAction: UIAlertAction!) {
        deleteMsgIndexPath = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showLoadingView()
        let selectedUserImage = messages[indexPath.row].senderImage
        let selectedOtherUID  = messages[indexPath.row].senderUID
        ChatVCvm.getUserDocumentData(uid: selectedOtherUID, dp: db) { [weak self] (result) in
            guard self != nil else {return}
            switch result {
            case .success(let data):
                self?.hideLoadingView()
                let vc = ChatVC()
                vc.otherUserID    = selectedOtherUID
                vc.otherUser      = data
                vc.otherUserImage = selectedUserImage
                #warning("pass other user name to the next controller")
                self?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                self?.hideLoadingView()
                guard error.userNotExist else {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                self?.showAlert(title: "Error", message: "This user doesn't exist")
            }
        }
    }
    
    
}


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

