//
//  headerCollectionViewCell.swift
//  weNotes
//
//  Created by youssef on 2/8/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

protocol headerCollectionViewCellProtocal {
    func Feeds()
    func stream()
    func openLiveStreamOfThisIndex()
}

class headerCollectionViewCell: UICollectionReusableView {
    
    var deleget : headerCollectionViewCellProtocal?
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var feedBtn: UIButton!
    @IBOutlet weak var saySamethingtf: TextField!
    
    @IBOutlet weak var streamBtn: UIButton!
    
    let cellIdentifier = "StoresCollectionViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpTableView()
    }
    
    func setUpTableView(){
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        setButtonConfegration(sender: feedBtn)
    }
    
    
    @IBAction func streamButton(_ sender: UIButton) {
        self.saySamethingtf.alpha = 0.0
        UIView.animate(withDuration: 0.7, animations: {
             self.saySamethingtf.isHidden = true
            
            self.setButtonConfegrationUnselected(sender: self.feedBtn)
            self.setButtonConfegration(sender: sender)
             self.deleget?.stream()
        })
        
        
    }
    
    @IBAction func feedsButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.deleget?.Feeds()
             self.saySamethingtf.isHidden = false
           
        }){ (_) in
            UIView.animate(withDuration: 0.7) {
                
                self.saySamethingtf.alpha = 1
                self.setButtonConfegrationUnselected(sender: self.streamBtn)
                self.setButtonConfegration(sender: sender)
                  
            }
        }
    }
   
    let bottomLine = CALayer()
    func setButtonConfegration(sender : UIButton){
         
        bottomLine.frame = CGRect(x: 20.0, y: sender.frame.height - 1, width: sender.frame.width - 40, height: 3.0)
        bottomLine.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.6, blue: 0.7529411765, alpha: 1)
        sender.layer.addSublayer(bottomLine)
        sender.setTitleColor(.black, for: .normal)
    }
    
    func setButtonConfegrationUnselected(sender : UIButton){
        bottomLine.removeFromSuperlayer()
        sender.setTitleColor(#colorLiteral(red: 0.5960784314, green: 0.6156862745, blue: 0.6470588235, alpha: 1), for: .normal)
    }
    
}
extension headerCollectionViewCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.height)
        return CGSize(width: 150, height: 200)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleget?.openLiveStreamOfThisIndex()
    }
    
    
    
}
