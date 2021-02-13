//
//  ShippingAdress.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class ShippingAdress: UIViewController {

    let textViewPlaceHolder = "Your adress for shipping"
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCustomTitleViewInEditProfile(with: "Shipping adress")
        self.tapGestureOnScreen()
        Utility.designSingsButtons(saveBtn)
        Utility.configureUserTextView(textView, placeholder: textViewPlaceHolder)
        textView.delegate = self

    }

}

extension ShippingAdress : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView){
        //This is TextView Placeholder
        if (textView.text == textViewPlaceHolder && textView.textColor == .lightGray){
            textView.text = ""
            if #available(iOS 13.0, *) {
                textView.textColor = .label
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if (textView.text == ""){
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
