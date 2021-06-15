//
//  TopMessagesView.swift
//  SLS
//
//  Created by Hady on 1/29/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class TopMessageView : UIView {
    
    let friendOnlineState  = UILabel()
    let friendUsername     = UILabel()
    
    let userImage          = UIImageView()
    let onlineStateImage   = UIImageView()
    var recievedImg   : UIImage?
    var otherUserName : String?
    var isOnline : Bool?
    
    let seperatorView      = UIView()
    let stackView = UIStackView()
    let padding : CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    init(img : UIImage , otherUserName : String , isOnline : Bool) {
        super.init(frame: .zero)
        self.recievedImg = img
        self.otherUserName = otherUserName
        self.isOnline = isOnline
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        let subViews = [friendOnlineState , friendUsername , userImage , onlineStateImage , stackView , seperatorView]
        for view in subViews {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        
        configureStackView()
        configureFriendImage()
        checkUserAvilability()

        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor ,constant: 80),
            userImage.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -padding),
            userImage.heightAnchor.constraint(equalToConstant: 47),
            userImage.widthAnchor.constraint(equalToConstant: 47),
            userImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            onlineStateImage.heightAnchor.constraint(equalToConstant: 15),
            onlineStateImage.widthAnchor.constraint(equalToConstant: 15),
            onlineStateImage.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -4),
            onlineStateImage.topAnchor.constraint(equalTo: self.topAnchor, constant: (100 - 47) / 2),
            
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            seperatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2),
            seperatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5)
            
        ])
        self.backgroundColor = .white
        seperatorView.backgroundColor = .lightGray
    }
    
    private func configureStackView(){
        stackView.addArrangedSubview(friendUsername)
        stackView.addArrangedSubview(friendOnlineState)
        stackView.contentMode  = .scaleToFill
        stackView.spacing      = 8
        stackView.distribution = .fill
        stackView.axis         = .vertical
        
        // configring stack view SubViews
        friendUsername.font         = UIFont.systemFont(ofSize: 22, weight: .bold)
        if #available(iOS 13.0, *) {
            friendUsername.textColor    = .label
        } else {
            // Fallback on earlier versions
        }
        friendUsername.text         = otherUserName
        
        friendOnlineState.font      = UIFont.systemFont(ofSize: 15)
        if #available(iOS 13.0, *) {
            friendOnlineState.textColor = .label
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func configureFriendImage(){
        if let recievedImg = recievedImg { userImage.image  = recievedImg }
        else { userImage.image = UIImage(named: "icon8-user")}
        userImage.contentMode = .scaleAspectFill
        userImage.layer.cornerRadius  = 18
        userImage.layer.masksToBounds = true
        userImage.clipsToBounds       = true
    }
    
    private func checkUserAvilability(){
        guard let online = isOnline else { return }
        if online { userOnline() }
            else {  userOffline() }
    }
    
    private func userOffline(){
        #warning("Set the offline image if existed")
        onlineStateImage.image      = UIImage()
        friendOnlineState.text      = "Offline"
        friendOnlineState.textColor = .gray
    }
    
    private func userOnline(){
        onlineStateImage.image      = UIImage(named: "active")
        friendOnlineState.text      = "Online"
        friendOnlineState.textColor =  UIColor.rgb(red: 20, green: 195, blue: 160)
    }
}

