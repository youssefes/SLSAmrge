//
//  EmptyStateVC.swift
//  SLS
//
//  Created by Hady on 1/30/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class EmptyStateVC: UIView {
    
    let messageLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
         configureVC()
         configureMessageLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureVC(){
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        self.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureMessageLabel(){
        messageLabel.text          = "Nothing here"
        messageLabel.textAlignment = .center
        if #available(iOS 13.0, *) {
            messageLabel.textColor     = .secondaryLabel
        } else {
            // Fallback on earlier versions
        }
        messageLabel.font          = UIFont.systemFont(ofSize: 35)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
