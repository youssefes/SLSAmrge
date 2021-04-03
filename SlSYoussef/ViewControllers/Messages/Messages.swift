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
    var currentlyUserUid  = ""
    var numOfMessages     = 0
    var isClicked         = false
    let emptyStateView    = EmptyStateVC()
    let db                = Firestore.firestore()
    var otherUserID : String?
    var currentUser : UserDataModel?
    var messages = [MessageData] ()
    var ChannelsData : [ChannelData]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = UtilityFunctions.user else {
            return
        }
        
        currentlyUserUid = user.uid!
        self.currentUser = user
        loadUserMessages()
        creatNavigationBarButtons()
        configureTableView()
        configureSearchController()
        //    navigationController?.hidesBarsOnSwipe = true
        
    }
    
    func loadUserMessages(){
        var channelId   : String?
        db.collection(User.user).document(currentlyUserUid).collection("engagedChatChannels").getDocuments { (snapshots, error) in

            guard let snapshot = snapshots , error == nil else {
                self.showAlert(title: "Error", message: "This user has no messages")
                //Clear button pressed
                return
            }
            self.numOfMessages = snapshot.count
            print(snapshot.count)
            for document in snapshot.documents {
                
                if self.isClicked { self.emptyStateView.removeFromSuperview() }
                let data = document.data()
                guard let chnlID = data["channelId"] as? String else {
                    print("This channel id is wrong!")
                    return
                }
                channelId = chnlID
                if let channelId = channelId { self.headingToChannelID(channelID : channelId) }
                
            }
        }
    }
    
    func headingToChannelID(channelID : String ) {

        db.collection("chatChannels").document(channelID).getDocument { (snapshot, error) in
            if error == nil , ((snapshot?.exists) != nil) {
                let data = snapshot?.data()
                guard let userIds = data!["userIds"] as? Array<String> else {
                    print("Can not convert UsserIds into array of string fkng string man!")
                    return
                }
                
                for id in userIds {
                    if id != self.currentlyUserUid { self.otherUserID = id}
                }
                self.getImageAndName(otherUserID: self.otherUserID, channelID: channelID)

            }
        }

    }
    
    func getImageAndName(otherUserID : String? ,channelID : String ){
        var profileImgUrl  : String?
        var userName       : String?
        var onlineState     : Bool?
        if otherUserID != nil {
            db.collection(User.user).document(otherUserID!).getDocument { (snapshot, error) in
                if error == nil , ((snapshot?.exists) != nil) {
                    let data = snapshot?.data()
                    if let data = data {
                        profileImgUrl = data["profileImg"] as? String
                        userName      = data["userName"] as? String
                        #warning("rememper to handle image force unwarpping")
                        #warning("Set default sender picture into chatCell")
                        ImagesOperations.DownloadImage(url: profileImgUrl!) { (img) in
                            self.retrieveLastMessage(channelID: channelID) { (msgBody,date)  in
                                let msgData = MessageData(messageTime: "\(date)", messageBody: msgBody, senderImage: img, senderName: userName!, senderUID: otherUserID!)
                                print("this is msg date \(date)")
                                self.messages.append(msgData)
                                self.numberOfMessagesLabel.text = "You have \(self.messages.count) new Messages"
                                self.tableView.reloadData()
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func retrieveLastMessage(channelID : String , completed : @escaping(_ messageBody : String , _ msgDate : Date) -> Void ){
        db.collection("chatChannels").document(channelID).collection("messages").order(by: "time").getDocuments { (snapshot, error) in
            if error == nil , ((snapshot?.isEmpty) != nil) {
                print(snapshot?.count)
                for document in snapshot!.documents.reversed() {
                    let data = document.data()
                    if let msg  = data["text"] as? String , let date  = ImagesOperations.trans(data: data){
                        completed(msg, date)
                        break
                    }else if let _ = data["imgUrl"] as? String, let date = ImagesOperations.trans(data: data){
                        completed("📷", date)
                        break
                    }
                    
                    else {
                        self.showAlert(title: "Error", message: "Error while fetching last message from this user")
                        completed("Error", Date())
                        break
                    }
                    
                        
                    
                }
            }
        }
        
//        db.collection("chatChannels").document(channelID).collection("messages").order(by: "time").getDocuments { (snapshot, error) in
//            if error == nil , ((snapshot?.isEmpty) != nil) {
//                for document in snapshot!.documents {
//                    let data = document.data()
//                }
//            }
//        }
    }
    @IBAction func clearAllButton(_ sender: Any) {
        if !isClicked{
            numOfMessages = 0
            tableView.reloadData()
            createEmptyStateView()
            print("createEmptyStateView")
            isClicked.toggle()
            dismiss(animated: true, completion: nil)
        }
        else {
            emptyStateView.removeFromSuperview()
            numOfMessages = messages.count
            print("Deleted!")
            
            tableView.reloadData()
            isClicked.toggle()
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
        print("Swiped")
    }
    
    private func configureTableView(){
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: ChatCell.cellIdentifier)
        tableView.rowHeight  = UITableView.automaticDimension
        tableView.rowHeight  = 100
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func configureSearchController(){
        let search = UISearchController()
        search.searchResultsUpdater     = self
        search.searchBar.delegate       = self
        search.searchBar.placeholder    = "type name here"
        navigationItem.searchController = search
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfMessages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellIdentifier, for: indexPath) as! ChatCell
        _ = indexPath.row
        _ = messages.count
        cell.messageTime.text  = messages[indexPath.row].messageTime
        cell.messageBody.text  = messages[indexPath.row].messageBody
        cell.senderImage.image = messages[indexPath.row].senderImage
        cell.senderName.text   = messages[indexPath.row].senderName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //HadyHelal :3gmxFkvwtaXXy7TQVkyvbVdWbze2 11 , Hulk: bnYfR5HVogOkXyBZrciMzmXeL6T2  8+
        self.showLoadingView()
        if let otherID = otherUserID {
            let selectedUserImage = messages[indexPath.row].senderImage
            ChatVCvm.getUserDocumentData(uid: otherID, dp: db) { [weak self] (result) in
                guard self != nil else {return}
                switch result {
                case .success(let data):
                    self?.hideLoadingView()
                    let vc = ChatVC()
                    vc.otherUserID    = otherID
                    vc.otherUser      = data
                    vc.otherUserImage = selectedUserImage
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

        }else {
            self.hideLoadingView()
            self.showAlert(title: "Error", message: "This user doesn't exist anymore")
        }
    }
}

extension Messages : UISearchResultsUpdating , UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text , !filter.isEmpty else {return}
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel!")
    }
}
