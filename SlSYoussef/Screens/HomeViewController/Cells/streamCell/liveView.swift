//
//  liveView.swift
//  SLS
//
//  Created by youssef on 2/8/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//


import UIKit
class liveView : NibLoadingView {
    @IBOutlet weak var iamgeOfVidew: UIImageView!
    @IBOutlet weak var viedeContainerView: UIView!
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var TimeLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUi()
    }
    func setupUi()  {
        viedeContainerView.cornerRadius = 20
        iamgeOfVidew.cornerRadius = 20
        viedeContainerView.borderWidth  = 1
        viedeContainerView.borderColor = .red
    }
}
