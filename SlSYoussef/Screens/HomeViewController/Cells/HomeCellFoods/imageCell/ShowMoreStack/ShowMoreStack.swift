//
//  ShowMoreStack.swift
//  SLS
//
//  Created by youssef on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

protocol ShowMoreProtocal : class {
    func showMore()
}

class ShowMoreStack: NibLoadingView {
    
    var isShowMore : Bool = true
    @IBOutlet weak var showMore: UIButton!
    
    weak var Deleget : ShowMoreProtocal?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    @IBAction func showMoreBtn(_ sender: Any) {
        if isShowMore == true {
            Deleget?.showMore()
        }
    }
    
}
