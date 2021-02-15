//
//  RegisterationCompletedViewController.swift
//  SLS
//
//  Created by Hady on 2/8/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class RegisterationCompletedViewController: UIViewController {

    let topView            = UIView()
    let botView            = UIView()
    
    let SLSImageView       = UIImageView()
    let checkMarkImageView = UIImageView()
    let thanksLabel        = TitleLabel(textAlignment: .center, fontSize: 25)
    let thanksLabel2       = TitleLabel(textAlignment: .center, fontSize: 25)
    
    let exclamationMark    = UIImageView()
    let messageLable       = SecondaryLabel(fontSize: 35)
    let cancelButton       = CustomButton(background: .systemBlue, title: "Close the app")
    let padding : CGFloat  = 20
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        configureUIElements()
        
        configureScreenViews()
        
        configureSISImageView()
        configureCheckMark()
        configureTitleLabels()
        
        configureExclamationMark()
        configureMessageLabel()
        configureCancelButton()
    }
    func configureUIElements(){
        let UITopView = [SLSImageView , checkMarkImageView , thanksLabel , thanksLabel2 ]
        for sub in UITopView {
            topView.addSubview(sub)
            sub.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let UIBotView = [exclamationMark , messageLable , cancelButton]
        for sub in UIBotView {
            botView.addSubview(sub)
            sub.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func configureScreenViews(){
        view.addSubview(topView)
        view.addSubview(botView)

        topView.translatesAutoresizingMaskIntoConstraints = false
        botView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            topView.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            botView.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: view.bounds.height / 2),
            
            botView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            botView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            botView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            botView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    

    
    private func configureSISImageView(){
        SLSImageView.image = UIImage(named: "logo")
        SLSImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            SLSImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: padding),
            SLSImageView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -padding),
            SLSImageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 80),
            SLSImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureCheckMark(){
        checkMarkImageView.image = UIImage(named: "checkMark")
        checkMarkImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            checkMarkImageView.topAnchor.constraint(equalTo: SLSImageView.bottomAnchor, constant: 20),
            checkMarkImageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            checkMarkImageView.heightAnchor.constraint(equalToConstant: 45),
            checkMarkImageView.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureTitleLabels(){
        thanksLabel.text  = "Thank you"
        thanksLabel2.text = "for registeration."

        thanksLabel.font  = UIFont(name: "kefa", size: 30)
        thanksLabel2.font = UIFont(name: "kefa", size: 30)
        
        if #available(iOS 13.0, *) {
            thanksLabel.textColor  = .secondaryLabel
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            thanksLabel2.textColor = .secondaryLabel
        } else {
            // Fallback on earlier versions
        }
        
        NSLayoutConstraint.activate([
            thanksLabel.topAnchor.constraint(equalTo: checkMarkImageView.bottomAnchor, constant: 8),
            thanksLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            thanksLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            thanksLabel2.topAnchor.constraint(equalTo: thanksLabel.bottomAnchor),
            thanksLabel2.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            thanksLabel2.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
        ])
    }
        
    private func configureExclamationMark(){
        exclamationMark.image       = UIImage(named: "exclamation")
        exclamationMark.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            exclamationMark.topAnchor.constraint(equalTo: botView.topAnchor, constant: 20),
            exclamationMark.heightAnchor.constraint(equalToConstant: 45),
            exclamationMark.widthAnchor.constraint(equalToConstant: 45),
            exclamationMark.centerXAnchor.constraint(equalTo: botView.centerXAnchor)
            
        ])
    }
    
    private func configureMessageLabel(){
        messageLable.text = "Your request has been request to an adminstrator, once accepted we will send you a confirmation by E-mail."
        messageLable.font = UIFont(name: Font.Bold.name, size: 25)
        messageLable.textAlignment = .center
        NSLayoutConstraint.activate([
            messageLable.topAnchor.constraint(equalTo: exclamationMark.bottomAnchor, constant: 20),
            messageLable.leadingAnchor.constraint(equalTo: botView.leadingAnchor , constant: 20),
            messageLable.trailingAnchor.constraint(equalTo: botView.trailingAnchor , constant: -20),
        ])
    }
    
    private func configureCancelButton(){
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: botView.bottomAnchor, constant:  -padding),
            cancelButton.leadingAnchor.constraint(equalTo: botView.leadingAnchor , constant: padding),
            cancelButton.trailingAnchor.constraint(equalTo: botView.trailingAnchor , constant: -padding),
        ])
        
    }

    
}
