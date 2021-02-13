//
//  ProfileSetting VM.swift
//  SLS
//
//  Created by Hady on 2/8/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

public struct  ProfileSettingVM {
    public let settingNames = ["Edit profile" , "Shipping address" , "Payment methods" , "My orders" , "Notifications setting" , "Customer support"]
    
    let settingImages  = ["edit" ,"shipping","payment","orders","notification profile","support"]
    let editVC         = EditProfile()
    let shippingVc     = ShippingAdress()
    let paymentVc      = PaymentMethods()
    let myOrder        = MyOrders()
    let notificationVc = NotificationSettings()
    let customerVC     = CustomerSupport()
    var destinationVCs : [UIViewController] {
         return  [editVC , shippingVc , paymentVc , myOrder , notificationVc , customerVC]
    }


    public func configureBecomeSellerButton(btn : UIButton){
        btn.layer.cornerRadius = 7
        btn.clipsToBounds      = true
        btn.layer.borderColor  = UIColor.darkGray.cgColor
        btn.layer.borderWidth  = 1
    }
    
    public mutating func configureUserImage(img : UIImageView){
        img.layer.cornerRadius = 50
        img.clipsToBounds      = true
    }
    
}
