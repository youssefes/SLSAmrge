//
//  ChatVC.swift
//  SLS
//
//  Created by Hady on 1/26/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import MessageKit

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        setTheTopMessageView()
     
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
                                messageId: "6",
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
    
    private func configureCollectionView() {
        messagesCollectionView.messagesDataSource      = self
        messagesCollectionView.messagesLayoutDelegate  = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        
        messagesCollectionView.addGestureRecognizer(gesture)
    }
    
    private func setTheTopMessageView() {
        let subView = TopMessageView()
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
        
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: messagesCollectionView.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: messagesCollectionView.trailingAnchor),
            subView.topAnchor.constraint(equalTo: messagesCollectionView.topAnchor),
            subView.heightAnchor.constraint(equalToConstant: 100)
            
        ])
        if #available(iOS 13.0, *) {
            subView.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
        messagesCollectionView.contentInset.top = 110
    }
    
    @objc func dismissKeyBoard(){
        view.endEditing(true)
        messagesCollectionView.endEditing(true)
        
        let controller = ChatVC()
        controller.resignFirstResponder()
        
        print("==================================")
    }
}

extension ChatVC : MessagesLayoutDelegate , MessagesDisplayDelegate {}
