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
        let Massage = UIButton.init(type: .custom)
           Massage.setImage(#imageLiteral(resourceName: "Message"), for: .normal)
        
        let Notification = UIButton.init(type: .custom)
                Notification.setImage(#imageLiteral(resourceName: "Notification-1"), for: .normal)
        
        let Profile = UIButton.init(type: .custom)
                Profile.setImage(#imageLiteral(resourceName: "hady"), for: .normal)
        Profile.cornerRadius = 20
        Profile.clipsToBounds = true
        Profile.widthAnchor.constraint(equalToConstant: 40).isActive = true
        Profile.heightAnchor.constraint(equalToConstant: 40).isActive = true
        Profile.translatesAutoresizingMaskIntoConstraints = false
        Profile.addTarget(self, action: #selector(ShowProfile), for: .touchUpInside)
        
        
        let home = UIButton.init(type: .custom)
        home.setImage(#imageLiteral(resourceName: "Home_icon"), for: .normal)
        Profile.addTarget(self, action: #selector(ShowHome), for: .touchUpInside)
        let back = UIButton.init(type: .custom)
        back.setImage(#imageLiteral(resourceName: "Layer 7"), for: .normal)
        
        let search = UIButton.init(type: .custom)
        search.setImage(#imageLiteral(resourceName: "shearch"), for: .normal)
        
        
        let Rightstackview = UIStackView.init(arrangedSubviews: [Massage , Notification , Profile])
        Rightstackview.distribution = .equalSpacing
        Rightstackview.axis = .horizontal
        Rightstackview.spacing = 20
        Rightstackview.translatesAutoresizingMaskIntoConstraints = false
        
        
        let Leftstackview = UIStackView.init(arrangedSubviews: [back,home , search])
        Leftstackview.distribution = .equalSpacing
        Leftstackview.axis = .horizontal
        Leftstackview.spacing = 20
        Leftstackview.translatesAutoresizingMaskIntoConstraints = false
        
        let rightBarButton = UIBarButtonItem(customView: Rightstackview)
        let LeftBarButton = UIBarButtonItem(customView: Leftstackview)
        
        self.navigationItem.leftBarButtonItem = LeftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    @objc func ShowProfile(){
//        let profile = ProfileSetting()
//        navigationController?.pushViewController(profile, animated: true)
        
                let profile = ChatVC()
                navigationController?.pushViewController(profile, animated: true)
    }
    
    @objc func ShowHome(){
        print("show home")
    }
    
    
    func createSystemBarButton(sideBtn : UIButton) -> UIBarButtonItem{
        let menuBarItem = UIBarButtonItem(customView: sideBtn)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        return menuBarItem
    }
    func createSideUIButton(image : UIImage , type: ButtonSystemType?) -> UIButton {
        let sideBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35)) //create UIButton by it's custom dimensions
        
        // get the button the custom image
        if #available(iOS 13.0, *) {
            sideBtn.setBackgroundImage(image , for: .normal)
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
    
    func createUIButton(image : UIImage , type : ButtonAssestType ) -> UIButton {
        let sideBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25)) //create UIButton by it's custom dimensions
        
        // get the button the custom image
        sideBtn.setBackgroundImage(image , for: .normal)
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
        
        swipedRightAndUserWantsToDismiss()
    }
    
    @objc func messageButtonClicked(){
        let msgVC  = Messages()
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
        let notiVC = Notifications()
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

