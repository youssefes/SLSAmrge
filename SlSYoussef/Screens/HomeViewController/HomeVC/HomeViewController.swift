//
//  HomeViewController.swift
//  weNotes
//
//  Created by youssef on 2/7/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, CellFoodsWithCollectionOfImageProtocal,HomeCellProtocal  {
    
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    let tableCellIdentifier =  "HomeCellWithotImage"
    
    var isFeed : Bool = true
    
    var isShowMore : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        creatNavigationBarButtons()
        
    }
    
    func reloadCollection() {
        homeCollectionView.reloadData()
    }
    
    
    func presentFullScreen(ArrayOfImage: [UIImage]) {
        let fullScrrenImage =  FullScreenViewController()
        fullScrrenImage.modalPresentationStyle = .overFullScreen
        fullScrrenImage.ArrayOfImage = ArrayOfImage
        present(fullScrrenImage, animated: true, completion: nil)
    }
    
    func setUpTableView(){
    
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.register(HomeCellWithotImage.self, forCellWithReuseIdentifier: tableCellIdentifier)
        homeCollectionView.register(UINib(nibName: "headerCollectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCollectionViewCell")
        homeCollectionView.register(CellFoodsWithCollectionOfImage.self, forCellWithReuseIdentifier: "CellFoodsWithCollectionOfImage")
        homeCollectionView.register(StreamCell.self, forCellWithReuseIdentifier: "StreamCell")
    }

}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,headerCollectionViewCellProtocal{
    
    
    
    func showOptionS() {
        let optinVC = OptionVCViewController()
        optinVC.modalPresentationStyle = .overFullScreen
        present(optinVC, animated: true, completion: nil)
    }
    
    func showComments() {
        let CommentsOfPost = CommentsOfPostViewController()
        CommentsOfPost.modalPresentationStyle = .overFullScreen
        present(CommentsOfPost, animated: true, completion: nil)
    }
       
    func Feeds() {
        isFeed = true
        self.homeCollectionView.reloadData()
    }
    
    func stream() {
        isFeed = false
        
        self.homeCollectionView.reloadData()
        
    }
    
    func handelFollowAndUnFollow(isFollow: Bool) {
        print(isFollow)
    }
    func openLiveStreamOfThisIndex() {
        let catchVideoVC = CatchVideoViewController()
        catchVideoVC.modalPresentationStyle = .overFullScreen
        present(catchVideoVC, animated: true, completion: nil)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollectionViewCell", for: indexPath) as! headerCollectionViewCell
            header.deleget = self
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isFeed{
             return CGSize(width: collectionView.frame.width, height: 370)
        }else{
             return CGSize(width: collectionView.frame.width, height: 320)
        }
       
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if isFeed{
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            let dymCell = CellFoodsWithCollectionOfImage(frame: frame)
            dymCell.layoutIfNeeded()
            let targetSize = CGSize(width: view.frame.width, height: 50)
            let estmaitedSize = dymCell.systemLayoutSizeFitting(targetSize)
            let height = max(50+50 + 16, estmaitedSize.height)
            return CGSize(width: collectionView.frame.width, height: height)
        }else{
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            let dymCell = StreamCell(frame: frame)
            dymCell.layoutIfNeeded()
            let targetSize = CGSize(width: view.frame.width, height: 50)
            let estmaitedSize = dymCell.systemLayoutSizeFitting(targetSize)
            let height = max(50+50 + 16, estmaitedSize.height)
            return CGSize(width: collectionView.frame.width, height: height)
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isFeed{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFoodsWithCollectionOfImage", for: indexPath) as! CellFoodsWithCollectionOfImage
            cell.Deleget = self
            cell.CollectionViewContainer.Deleget = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StreamCell", for: indexPath) as! StreamCell
            cell.Deleget = self
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
    
    
    
    
}
