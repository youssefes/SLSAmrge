//
//  ContainerImageView.swift
//  SLS
//
//  Created by youssef on 2/8/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit
protocol  HomeCellProtocal : class{
    func presentFullScreen(ArrayOfImage : [UIImage])
}
class ContainerImageView: NibLoadingView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerImage: UIImageView!
    
    var arrayOfimage : [UIImage] = [#imageLiteral(resourceName: "Untitled design"), #imageLiteral(resourceName: "pppp"), #imageLiteral(resourceName: "ppp"),#imageLiteral(resourceName: "hady"),#imageLiteral(resourceName: "prof6")]
    weak var Deleget : HomeCellProtocal?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCollection()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpCollection()
    }
    
    func setUpCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImagesViewCell", bundle: nil), forCellWithReuseIdentifier: "ImagesViewCell")
        collectionView.register(UINib(nibName: "CillectionImageCellCollectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CillectionImageCellCollectionViewCell")
        headerImage.isUserInteractionEnabled = true
        let gusterTap = UITapGestureRecognizer()
        gusterTap.numberOfTouchesRequired = 1
        gusterTap.addTarget(self, action: #selector(heandleFullScreen))
        headerImage.addGestureRecognizer(gusterTap)
    }
    
    @objc func heandleFullScreen(){
        guard let HeaderImage = headerImage.image else {return}
        arrayOfimage.append(HeaderImage)
        Deleget?.presentFullScreen(ArrayOfImage: self.arrayOfimage)
    }

}

extension ContainerImageView : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrayOfimage.count == 2{
            let width = (view.frame.width ) / 2
            return CGSize(width: width, height: width)
        }else if arrayOfimage.count == 1{
            let width = (view.frame.width) / 1
            return CGSize(width: width, height: width)
        }else{
            let width = (view.frame.width - 20) / 3
            return CGSize(width: width, height: width)
        }
            
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrayOfimage.count > 1{
            headerImage.image = arrayOfimage.first
            
            arrayOfimage.remove(at: 0)
        }
        if arrayOfimage.count > 3 {
            return 3
        }else{
            return arrayOfimage.count
        }
        
    }
    
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesViewCell", for: indexPath) as! ImagesViewCell
        
        if indexPath.item == 2, arrayOfimage.count > 3{
            cell.numberOfImage.text = "+\(arrayOfimage.count - 3)"
            cell.numberOfImage.isHidden = false
            cell.photeView.image = arrayOfimage[indexPath.item]
            cell.viewAlphe.isHidden = false
            return cell
        }
        
        cell.photeView.image = arrayOfimage[indexPath.item]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let HeaderImage = headerImage.image else {return}
        arrayOfimage.append(HeaderImage)
        Deleget?.presentFullScreen(ArrayOfImage: self.arrayOfimage)
    }


}
