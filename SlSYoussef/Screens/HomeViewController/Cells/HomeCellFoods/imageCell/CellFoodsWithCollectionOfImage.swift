//
//  CellFoodsWithCollectionOfImage.swift
//  weNotes
//
//  Created by youssef on 2/8/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
protocol CellFoodsWithCollectionOfImageProtocal : class {
    func reloadCollection()
    func handelFollowAndUnFollow(isFollow : Bool)
    func showOptionS()
    func showComments()
}

class CellFoodsWithCollectionOfImage : UICollectionViewCell, ShowMoreProtocal{
    var isFollow  = false
    var islike  = false
    weak var Deleget : CellFoodsWithCollectionOfImageProtocal?
    var arrayOfimage : [UIImage] = [#imageLiteral(resourceName: "Group 528")]
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
    
    
    let profileImage : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "pp")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
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
        button.titleLabel?.font = UIFont(name: Font.Bold.name, size: 10)
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
    
    lazy var PostTextView : UITextView = {
        let TextView = UITextView()
        TextView.isScrollEnabled = false
        TextView.isEditable = false
        TextView.text = "premium rose pink rib knit boyfriend style   hoodie with side splits and dropped back  hem.  check out the matching co-ord, search style   code -k2233303  oversized fit - for a more snug fit, try  sizing down!  bum grazer - sits on bum  66% acrylic 31% polpremium rose pink rib knit boyfriend style   hoodie with side splits and dropped back  hem.  check out the matching co-ord, search style   code -k2233303  oversized fit - for a more snug fit, try  sizing down!  bum grazer - sits on bum  66% acrylic 31% polpremium rose pink rib knit boyfriend style   hoodie with side splits and dropped back  hem.  check out the matching co-ord, search style   code -k2233303  oversized fit - for a more snug fit, try  sizing down!  bum grazer - sits on bum  66% acrylic 31% polpremium rose pink rib knit boyfriend style   hoodie with side splits and dropped back  hem.  check out the matching co-ord, search style   code -k2233303  oversized fit - for a more snug fit, try  sizing down!  bum grazer - sits on bum  66% acrylic 31% polpremium rose pink rib knit boyfriend style   hoodie with side splits and dropped back  hem.  check out the matching co-ord, search style   code -k2233303  oversized fit - for a more snug fit, try  sizing down!  bum grazer - sits on bum  66% acrylic 31% pol"
        TextView.backgroundColor = .clear
        TextView.font = UIFont.boldSystemFont(ofSize: 14)
        return TextView
    }()
    
    lazy var optionButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Group 661"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showOption), for: .touchUpInside)
        return button
    }()
    
    lazy var likeButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "likePost"), for: .normal)
        button.addTarget(self, action: #selector(handelLikeBtn), for: .touchUpInside)
        return button
    }()
    
    @objc func handelLikeBtn(){
        islike = !islike
        if islike{
            likeButton.setImage(#imageLiteral(resourceName: "LikeComponent"), for: .normal)
        }else{
            likeButton.setImage(#imageLiteral(resourceName: "likePost"), for: .normal)
        }
    }
    
    @objc func showOption(){
        Deleget?.showOptionS()
    }
    
    lazy var CommitButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handelComment), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "Comment-1"), for: .normal)
        return button
    }()
    
    lazy var bookmarkButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Comment"), for: .normal)
        return button
    }()
    
    lazy var ShopNewBtn : UIButton = {
        let button = UIButton()
        button.setTitle("Shop Now 25€", for: .normal)
        button.titleLabel?.font = UIFont(name: Font.Bold.name, size: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.6, blue: 0.7529411765, alpha: 1)
        button.cornerRadius = 5
        return button
    }()
    
    lazy var SendMassbtn : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "emailIcon"), for: .normal)
        button.borderColor = #colorLiteral(red: 0.8666666667, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        button.borderWidth = 2
        button.shadowColor = #colorLiteral(red: 0.8666666667, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        button.shadowRadius = 8
        button.shadowOpacity = 0.1
        button.shadowOffset = CGPoint(x: 10, y: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    lazy var LineView : UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        return view
    }()
    
    lazy var showMoreView : ShowMoreStack = {
        let view = ShowMoreStack()
        view.Deleget = self
        return view
    }()
    
    
    
    let CollectionViewContainer = ContainerImageView()
    
    lazy var  stackView = UIStackView(arrangedSubviews: [likeButton,CommitButton,bookmarkButton])
    
    @objc func handelComment(){
        Deleget?.showComments()
    }
    
    @objc func handledFollowanEdited(){
        isFollow = !isFollow
        
        if isFollow{
            followBtn.setTitleColor(#colorLiteral(red: 0.5137254902, green: 0.5098039216, blue: 0.5098039216, alpha: 1), for: .normal)
            followBtn.setTitle("Unfollow", for: .normal)
            followBtn.borderColor = #colorLiteral(red: 0.5137254902, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        }else{
            followBtn.setTitleColor(#colorLiteral(red: 0.2078431373, green: 0.5764705882, blue: 1, alpha: 1), for: .normal)
            followBtn.setTitle("Follow", for: .normal)
            followBtn.borderColor = #colorLiteral(red: 0.2078431373, green: 0.5764705882, blue: 1, alpha: 1)
        }
        
        Deleget?.handelFollowAndUnFollow(isFollow: isFollow)
    }
    
    
    var hightAnchorOfTextViewPost : NSLayoutConstraint?
    
    func showMore() {
        hightAnchorOfTextViewPost?.isActive =  false
    }
    
    func showLess() {
        
        
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.cornerRadius = 30
        self.clipsToBounds = true
        addSubview(profileImage)
        addSubview(userNameLbl)
        addSubview(optionButton)
        addSubview(timaCreationLbl)
        addSubview(followBtn)
        
        
        backgroundColor = .white
        profileImage.anchor(top: topAnchor, bottom: nil , left: leftAnchor, right: nil, padingTop: 20, padingBotton: 0, padingLeft: 18, padingRight: 0, width: 40, height: 40)
        profileImage.layer.cornerRadius = 40 / 2
        
        userNameLbl.anchor(top: profileImage.topAnchor, bottom: nil, left: profileImage.rightAnchor, right: followBtn.leftAnchor, padingTop: 0, padingBotton: 0, padingLeft: 8, padingRight: 0, width: 0, height: 0)
        
        timaCreationLbl.anchor(top:  nil, bottom: profileImage.bottomAnchor, left: profileImage.rightAnchor, right: followBtn.leftAnchor, padingTop: 0, padingBotton: 0, padingLeft: 8, padingRight: 0, width: 0, height: 0)
        
        optionButton.anchor(top: topAnchor, bottom: profileImage.bottomAnchor, left: nil, right: rightAnchor, padingTop: 0, padingBotton: 0, padingLeft: 0, padingRight: 0, width: 44, height: 0)
        
        followBtn.anchor(top: topAnchor, bottom: nil, left: nil, right: optionButton.leftAnchor, padingTop: 20, padingBotton: 0, padingLeft: 0, padingRight: 0 , width: 100 , height: 20)
        
        addSubview(PostTextView)
        hightAnchorOfTextViewPost = PostTextView.heightAnchor.constraint(equalToConstant: 100)
        PostTextView.anchor(top: profileImage.bottomAnchor, bottom: nil, left: profileImage.leftAnchor, right: optionButton.leftAnchor, padingTop: 12, padingBotton: 0, padingLeft: 8, padingRight: 8, width: 0, height: 0)
        hightAnchorOfTextViewPost?.isActive = true
        addSubview(showMoreView)
        
        showMoreView.anchor(top: PostTextView.bottomAnchor, bottom: nil, left: PostTextView.leftAnchor, right: PostTextView.rightAnchor, padingTop: 10, padingBotton: 0, padingLeft: 0, padingRight: 0, width: 0, height: 30)
        
        setUpActionButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpActionButton(){
        
        
        addSubview(CollectionViewContainer)
        CollectionViewContainer.anchor(top: showMoreView.bottomAnchor, bottom: nil, left: profileImage.leftAnchor, right: optionButton.rightAnchor, padingTop: 20, padingBotton: 10, padingLeft: 0, padingRight: -20 , width: 0, height: 300)
        
        let statckViewWithShopBtn = UIStackView(arrangedSubviews: [SendMassbtn, ShopNewBtn])
        addSubview(statckViewWithShopBtn)
        statckViewWithShopBtn.spacing = 10
        statckViewWithShopBtn.anchor(top: CollectionViewContainer.bottomAnchor, bottom: nil, left: CollectionViewContainer.leftAnchor, right: CollectionViewContainer.rightAnchor, padingTop: 20, padingBotton: 0, padingLeft: 0, padingRight: 0, width: 0, height: 40)
        addSubview(stackView)
        addSubview(LineView)
        stackView.distribution = .fillEqually
        
        
        LineView.anchor(top: statckViewWithShopBtn.bottomAnchor, bottom : nil , left: statckViewWithShopBtn.leftAnchor, right: statckViewWithShopBtn.rightAnchor, padingTop: 20, padingBotton: 0, padingLeft: 0, padingRight: 0, width: 0, height: 1)
        
        stackView.anchor(top: LineView.bottomAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, padingTop: 0, padingBotton: 20, padingLeft: 20, padingRight: -20, width: 0, height: 50)
    }
    
}


