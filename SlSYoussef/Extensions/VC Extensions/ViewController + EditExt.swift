//
//  ViewController + EditExt.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

enum ExitBack : String {
    case exit = "exit"
    case back = "back"
}

extension UIViewController {
    func createCustomTitleViewInEditProfile(with title : String){
        let exitButton =  createSystemBarButton(sideBtn: createSideUIButton(image: #imageLiteral(resourceName: "Layer 24"), type: nil))
        let backButton =  createSystemBarButton(sideBtn: createSideUIButton(image: #imageLiteral(resourceName: "Arrow   Left 2"), type: nil))
        
        navigationItem.leftBarButtonItems  = [backButton]
        navigationItem.rightBarButtonItems = [exitButton]
        navigationItem.title               = title

    }
    
    @objc func exitePressed(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func createCustomTVRegisteration(rightSideBtnTitle : String){
        let backButton =  createSystemBarButton(sideBtn: createUIButton(image: #imageLiteral(resourceName: "BackBtnIcon"), type: .back))
        
        let view = UIView()
        let button = UIButton(type: .system)
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitle(rightSideBtnTitle, for: .normal)
        button.addTarget(self, action: #selector(exitePressed), for: .touchUpInside)
        button.sizeToFit()
        view.addSubview(button)
        view.frame = button.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
        navigationItem.leftBarButtonItems  = [backButton]
    }

}
