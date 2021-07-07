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
    
    let settingImages : [UIImage]  = [#imageLiteral(resourceName: "suggest"), #imageLiteral(resourceName: "shipping-1"), #imageLiteral(resourceName: "payment-1"),#imageLiteral(resourceName: "finished"), #imageLiteral(resourceName: "005-bell"), #imageLiteral(resourceName: "support-1")]
    let editVC         = EditProfile()
    let shippingVc     = ShippingAdress()
    let paymentVc      = PaymentMethods()
    let myOrder        = MyOrders()
    let notificationVc = NotificationSettings()
    let customerVC     = CustomerSupport()
    var destinationVCs : [UIViewController] {
         return  [editVC , shippingVc , paymentVc , myOrder , notificationVc , customerVC]
    }

}
