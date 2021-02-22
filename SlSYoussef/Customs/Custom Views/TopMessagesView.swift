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
    
    let seperatorView      = UIView()
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
        let subViews = [friendOnlineState , friendUsername , userImage , onlineStateImage , stackView , seperatorView]
        for view in subViews {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        
        configureStackView()
        configureFriendImage()

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
        friendUsername.text         = "Hady Helal"
        
        friendOnlineState.font      = UIFont.systemFont(ofSize: 15)
        if #available(iOS 13.0, *) {
            friendOnlineState.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        friendOnlineState.text      = "Online"
        friendOnlineState.textColor =  UIColor.rgb(red: 20, green: 195, blue: 160)
   
    }
    
    private func configureFriendImage(){
        userImage.image       = UIImage(named: "ppp")
        userImage.contentMode = .scaleAspectFill
        userImage.layer.cornerRadius  = 18
        userImage.layer.masksToBounds = true
        userImage.clipsToBounds       = true
        
        onlineStateImage.image = UIImage(named: "active")
    }
}

