//
//  CustomNavBAr.swift
//  SLS
//
//  Created by Hady on 1/31/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import MessageKit

enum ButtonSystemType {
    case house
    case back
    case search
    case message
}

enum ButtonAssestType {
    case notification
    case profile
    case back
}
 
extension UIViewController {
    
    func creatNavigationBarButtons(){
        let house   = createSystemBarButton(sideBtn: createSideUIButton(imageSystemName: "house", type: .house))
        let back    = createSystemBarButton(sideBtn: createSideUIButton(imageSystemName: "arrow.left", type: .back))
        let search  = createSystemBarButton(sideBtn: createSideUIButton(imageSystemName: "magnifyingglass", type: .search))
        let message = createSystemBarButton(sideBtn: createSideUIButton(imageSystemName: "message", type: .message))
        
        let profile      = createSystemBarButton(sideBtn: createUIButton(imageName: "hady", type: .profile))
        let notification = createSystemBarButton(sideBtn: createUIButton(imageName: "notification", type: .notification))
        
        self.navigationItem.leftBarButtonItems  = [back , house , search]
        self.navigationItem.rightBarButtonItems = [profile , notification , message]

    }
    
    func createSystemBarButton(sideBtn : UIButton) -> UIBarButtonItem{
        let menuBarItem = UIBarButtonItem(customView: sideBtn)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        return menuBarItem
    }
    func createSideUIButton(imageSystemName : String , type: ButtonSystemType?) -> UIButton {
        let sideBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35)) //create UIButton by it's custom dimensions
        
        // get the button the custom image
        if #available(iOS 13.0, *) {
            sideBtn.setBackgroundImage(UIImage(systemName: imageSystemName) , for: .normal)
        } else {
            // Fallback on earlier versions
        }
        sideBtn.layer.cornerRadius = 15
        sideBtn.clipsToBounds = true
        
        // add the target to the butto
        switch type {
        case .house:
            sideBtn.addTarget(self, action: #selector(houseButton), for: .touchUpInside)
        case .back:
            sideBtn.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        case .search:
            sideBtn.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        case .message:
            sideBtn.addTarget(self, action: #selector(messageButtonClicked), for: .touchUpInside)
        case .none:
            sideBtn.addTarget(self, action: #selector(exitePressed), for: .touchUpInside)
        }
        return sideBtn
    }
    
    func createUIButton(imageName : String , type : ButtonAssestType ) -> UIButton {
        let sideBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25)) //create UIButton by it's custom dimensions
        
        // get the button the custom image
        sideBtn.setBackgroundImage(UIImage(named: imageName) , for: .normal)
        sideBtn.layer.cornerRadius = 15
        sideBtn.clipsToBounds = true
        
        // add the target to the button
        switch type {
        case .profile:
            sideBtn.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        case .notification:
            sideBtn.addTarget(self, action: #selector(notificationButtonClicked), for: .touchUpInside)
        case .back:
            sideBtn.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
        
        return sideBtn
    }
    
    @objc func houseButton(){
//        let messageVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC")
//        let MynavController = UINavigationController(rootViewController: messageVC!) as UIViewController
//        self.present(MynavController, animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func searchButtonPressed(){
        print("search btn pressed")
    }
    
    @objc func backButtonPressed(){
        //self.navigationController?.popViewController(animated: true)
        //print("back button")
        swipedRightAndUserWantsToDismiss()
    }
    
    @objc func messageButtonClicked(){
        let msgVC  = MessagesVC()
//        if isModal() {
//        navigationController?.popToViewController(msgVC, animated: true)
//        }
//        else {
            navigationController?.pushViewController(msgVC, animated: true)
        //}
    }

    @objc func profileButtonClicked(){
        print("Profile button clicked")
    }
    @objc func notificationButtonClicked(){
        let notiVC = NotificationVC()
        navigationController?.popToViewController(notiVC, animated: true)
    }
    
    
    func isModal() -> Bool {
        if((self.presentingViewController) != nil) {
            return true
        }
        
        if(self.presentingViewController?.presentedViewController == self) {
            return true
        }
        
        if(self.navigationController?.presentingViewController?.presentedViewController == self.navigationController) {
            return true
        }

        return false
    }
    
    @objc func swipedRightAndUserWantsToDismiss() {
        
        if self.isModal() == true {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

