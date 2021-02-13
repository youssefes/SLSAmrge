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
    
    let stackView = UIStackView()
    let padding : CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        let subViews = [friendOnlineState , friendUsername , userImage , onlineStateImage , stackView]
        for view in subViews {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
 
        configureStackView()
        configureFriendImage()
        
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor ,constant: 80),
            userImage.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -padding),
            userImage.heightAnchor.constraint(equalToConstant: 60),
            userImage.widthAnchor.constraint(equalToConstant: 60),
            userImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            onlineStateImage.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -4),
            onlineStateImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            onlineStateImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60-15+84),
            onlineStateImage.heightAnchor.constraint(equalToConstant: 15),
            
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
        ])
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
        friendUsername.text         = "Hady Helal"
        
        friendOnlineState.font      = UIFont.systemFont(ofSize: 15)
        if #available(iOS 13.0, *) {
            friendOnlineState.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        friendOnlineState.text      = "Online"
        friendOnlineState.textColor = .systemGreen
    }
    
    private func configureFriendImage(){
        userImage.image       = UIImage(named: "hady")
        userImage.contentMode = .scaleAspectFill
        userImage.layer.cornerRadius  = 20
        userImage.layer.masksToBounds = true
        userImage.clipsToBounds       = true
        
        onlineStateImage.image = UIImage(named: "active")
    }
}

