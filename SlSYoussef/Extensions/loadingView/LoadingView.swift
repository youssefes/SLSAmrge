//
//  LoadingView.swift
//  SLS
//
//  Created by youssef on 2/11/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingView :  NibLoadingView {

    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    func nibSetup(){
        loadingView.startAnimating()
    }

}
