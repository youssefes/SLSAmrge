//
//  HomeCellWithotImage.swift
//  LoftPop
//
//  Created by youssef on 1/26/21.
//  Copyright © 2021 youssef. All rights reserved.
//


import UIKit

class HomeCellWithotImage: UICollectionViewCell {
    
    //    var delegate : HomePostCellDeleget?
    
    //    var post : Posts?{
    //        didSet{
    //
    //            guard let caption = post?.caption else {
    //                return
    //            }
    //            guard let user = post?.user else {
    //                return
    //            }
    //
    //            guard let post = post else {
    //                return
    //            }
    //            likeButton.setImage(post.hasLike == true ? #imageLiteral(resourceName: "heart") : #imageLiteral(resourceName: "activity-selected"), for: .normal)
    //            PhotoImageView.loadImage(imageUrl: user.prrofilURlImage)
    //            let timpeToDisplay = post.creationDate.getPastTime(for: post.creationDate)
    //            timaCreationLbl.text = timpeToDisplay
    //            captionLbl.text = caption
    //            userNameLbl.text = user.userName
    //        }
    //    }
    
    
    let PhotoImageView : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Untitled design")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let userNameLbl : UILabel = {
        let label = UILabel()
        label.text = "youssef"
        label.font = UIFont(name: Font.Bold.name, size: 14)
        return label
    }()
    
    
    lazy var followBtn : UIButton = {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.2078431373, green: 0.5764705882, blue: 1, alpha: 1), for: .normal)
        button.cornerRadius = 12
        button.setTitle("Follow", for: .normal)
        button.borderColor = #colorLiteral(red: 0.2078431373, green: 0.5764705882, blue: 1, alpha: 1)
        button.borderWidth = 1
        button.addTarget(self, action: #selector(handledFollowanEdited), for: .touchUpInside)
        return button
    }()
    
    let timaCreationLbl : UILabel = {
        let label = UILabel()
        label.text = "1 hour age"
        label.font = UIFont(name: Font.Light.name, size: 10)
        label.textColor = UIColor.gray
        return label
    }()
    
    let PostTextView : UITextView = {
        let TextView = UITextView()
        TextView.isScrollEnabled = false
        TextView.isEditable = false
        TextView.text = "premium rose pink rib knit boyfriend style   hoodie with side splits and dropped back  hem.  check out the matching co-ord, search style   code -k2233303  oversized fit - for a more snug fit, try  sizing down!  bum grazer - sits on bum  66% acrylic 31% pol"
        TextView.backgroundColor = .clear
        TextView.font = UIFont.boldSystemFont(ofSize: 14)
        return TextView
    }()
    
    let optionButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Group 661"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var likeButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Like-1"), for: .normal)
        button.addTarget(self, action: #selector(handelLikeBtn), for: .touchUpInside)
        return button
    }()
    
    @objc func handelLikeBtn(){
        //        delegate?.didlike(for: self)
    }
    
    let sendMassageButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Comment-1"), for: .normal)
        return button
    }()
    
    let bookmarkButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Comment"), for: .normal)
        return button
    }()
    
    lazy var showMoreView : ShowMoreStack = {
        let view = ShowMoreStack()
        
        return view
    }()
    
    @objc func handelComment(){
        //        print("comment")
        //        guard let post = post else {
        //            return
        //        }
        //        delegate?.didTApComment(post: post)
    }
    
    @objc func handledFollowanEdited(){
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cornerRadius = 20
        self.clipsToBounds = true
        addSubview(PhotoImageView)
        addSubview(userNameLbl)
        addSubview(timaCreationLbl)
        addSubview(optionButton)
        addSubview(followBtn)
        backgroundColor = .white
        PhotoImageView.anchor(top: topAnchor, bottom: nil , left: leftAnchor, right: nil, padingTop: 8, padingBotton: 0, padingLeft: 20, padingRight: 0, width: 40, height: 40)
        PhotoImageView.layer.cornerRadius = 40 / 2
        
        userNameLbl.anchor(top: PhotoImageView.topAnchor, bottom: nil, left: PhotoImageView.rightAnchor, right: optionButton.leftAnchor, padingTop: 0, padingBotton: 0, padingLeft: 8, padingRight: 0, width: 0, height: 0)
        
        timaCreationLbl.anchor(top:  userNameLbl.bottomAnchor, bottom: PhotoImageView.bottomAnchor, left: PhotoImageView.rightAnchor, right: optionButton.leftAnchor, padingTop: 5, padingBotton: 0, padingLeft: 8, padingRight: 0, width: 0, height: 0)
        
        optionButton.anchor(top: topAnchor, bottom: PhotoImageView.bottomAnchor, left: nil, right: rightAnchor, padingTop: 0, padingBotton: 0, padingLeft: 0, padingRight: 0, width: 44, height: 0)
        
        followBtn.anchor(top: topAnchor, bottom: nil, left: nil, right: optionButton.leftAnchor, padingTop: 10, padingBotton: 0, padingLeft: 0, padingRight: 0 , width: 100 , height: 25)
        
        addSubview(PostTextView)
        PostTextView.anchor(top: PhotoImageView.bottomAnchor, bottom: nil, left: PhotoImageView.leftAnchor, right: optionButton.leftAnchor, padingTop: 12, padingBotton: 0, padingLeft: 8, padingRight: 8, width: 0, height: 0)
        
        
        addSubview(showMoreView)
        
        showMoreView.anchor(top: PostTextView.bottomAnchor, bottom: nil, left: PostTextView.leftAnchor, right: PostTextView.rightAnchor, padingTop: 10, padingBotton: 0, padingLeft: 0, padingRight: 0, width: 0, height: 30)
        
        setUpActionButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpActionButton(){
        let stackView = UIStackView(arrangedSubviews: [likeButton,sendMassageButton,bookmarkButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: showMoreView.bottomAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, padingTop: 12, padingBotton: 20, padingLeft: 20, padingRight: -20, width: 0, height: 40)
    }
    
}

