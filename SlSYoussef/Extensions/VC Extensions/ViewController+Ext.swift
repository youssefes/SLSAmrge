//
//  ViewController+Ext.swift
//  SLS
//
//  Created by Hady on 1/25/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

fileprivate var containerView : UIView!
extension UIViewController {
    //MARK: - Alerts
    func presentAlertOnMainThread(title: String , message: String , leftTitle: String , rightTitle: String){
        DispatchQueue.main.async {
            let alertVC = AlertVC(title: title, message: message, leftTitle: leftTitle , rightTitle: rightTitle )
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle   = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
    }

    func showAlert(title : String , message : String){
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Loading view
    func showLoadingView(is withlogo : Bool = false ){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        containerView.alpha  = 0
 
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        if #available(iOS 13.0, *) {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            containerView.addSubview(activityIndicator)
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            activityIndicator.startAnimating()
            
        } else {
            // Fallback on earlier versions
        }
        
         guard withlogo == true else {
            return
         }
        
        let logoImg = UIImageView(image: UIImage(named: "logo"))
        logoImg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImg)
        NSLayoutConstraint.activate([
            logoImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            logoImg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            logoImg.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            
        ])
        containerView.backgroundColor = .white
        containerView.alpha  = 1
    }
    
    func hideLoadingView(){
            containerView.removeFromSuperview()
            containerView = nil
    }
    
    //MARK: - Gestures
    func tapGestureOnScreen(){
        let gesture = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:)))
        view.addGestureRecognizer(gesture)
    }
    
}
