//
//  CommentsOfPostViewController.swift
//  SLS
//
//  Created by youssef on 2/11/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class CommentsOfPostViewController: UIViewController {
    @IBOutlet weak var numberOfComment: UILabel!
    
    @IBOutlet weak var commentcollectionView: UICollectionView!
    
    @IBOutlet weak var commentTf: UITextField!
    
    let cellIdentifier = "CommentofPostCellCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCommentCollectionView()
        // Do any additional setup after loading the view.
    }
    func setUpCommentCollectionView(){
        commentcollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        commentcollectionView.delegate = self
        commentcollectionView.dataSource = self
    }
    
    @IBAction func showOldestorNeewstbtn(_ sender: Any) {
    }
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendComment(_ sender: Any) {
    }
    
}

extension CommentsOfPostViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dymCell = CommentofPostCellCollectionViewCell(frame: frame)
        dymCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 50)
        let estmaitedSize = dymCell.systemLayoutSizeFitting(targetSize)
        let height = max(50+50+30 + 16, estmaitedSize.height)
        return CGSize(width: collectionView.frame.width, height: height)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CommentofPostCellCollectionViewCell
        
        return cell
    }
    
    
    
    
}
