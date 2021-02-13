//
//  AlertVC.swift
//  SLS
//
//  Created by Hady on 1/25/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    
    let containerView = UIView()
    //let titleLabel    = TitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel  = BodyLabel(textAlignment: .center)
    let leftButton    = CustomButton(background: .systemBlue, title: "Yes")
    let rightButton   = CustomButton(background: .systemPink, title: "No")
    let buttonStack   = UIStackView()

    
    var alertTitle   : String?
    var messageTitle : String?
    var leftButtonTitle  : String?
    var rightButtonTitle : String?
    
    let padding : CGFloat = 20 //For Constraints
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(title : String , message : String , leftTitle : String , rightTitle : String){
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle       = title
        self.messageTitle     = message
        self.leftButtonTitle  = leftTitle
        self.rightButtonTitle = rightTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
       // self.view.alpha = 0
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)

        
        configureContainerView()
       // configureTitleLabel()
        
        configureLeftButton()
        configureRightButton()
        
        configureStackButtons()
        configureMessageLabel()
    }
    
    
    func configureContainerView(){
        
        view.addSubview(containerView)
        if #available(iOS 13.0, *) {
            containerView.backgroundColor    = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth  = 2
        containerView.layer.borderColor  = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
        ])
    }
    
    
   /* func configureTitleLabel(){
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something Went Wrong!"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor , constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor , constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }*/
    
    func configureLeftButton(){
        leftButton.setTitle(leftButtonTitle ?? "Ok" , for: .normal)
        leftButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    func configureRightButton(){
        rightButton.setTitle(rightButtonTitle ?? "Ok" , for: .normal)
        rightButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
   func configureStackButtons(){
        buttonStack.addArrangedSubview(leftButton)
        buttonStack.addArrangedSubview(rightButton)
    
        containerView.addSubview(buttonStack)
    
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 15
        
        NSLayoutConstraint.activate([
            buttonStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            buttonStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            buttonStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            buttonStack.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    

    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.numberOfLines = 4
        messageLabel.text = messageTitle ?? "WTF is Going On!"
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: -12)
        ])
    }
    
}
