//
//  StreamCell.swift
//  SLS
//
//  Created by youssef on 2/8/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//


import UIKit

class StreamCell: UICollectionViewCell {
    
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
    
    weak var Deleget : CellFoodsWithCollectionOfImageProtocal?
    var isFollow  = false
    var isLike = false
    let profileImage : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Untitled design")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let ViedoImage : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Untitled design")
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
        button.titleLabel?.font = UIFont(name: Font.Bold.name, size: 12)
        button.addTarget(self, action: #selector(handledFollowanEdited), for: .touchUpInside)
        return button
    }()
    
    lazy var timaCreationLbl : UILabel = {
        let label = UILabel()
        label.text = "1 hour age"
        label.font = UIFont(name: Font.Light.name, size: 10)
        label.textColor = UIColor.gray
        return label
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
        isLike = !isLike
        if isLike{
           likeButton.setImage(#imageLiteral(resourceName: "LikeComponent"), for: .normal)
        }else{
           likeButton.setImage(#imageLiteral(resourceName: "likePost"), for: .normal)
        }
    }
    
    lazy var commetBtn : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Comment-1"), for: .normal)
        button.addTarget(self, action: #selector(handelComment), for: .touchUpInside)
        return button
    }()
    
    lazy var shareBtn : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Comment"), for: .normal)
        return button
    }()
    
    var VideoView : liveView = {
        var view = liveView()
        return view
    }()
    
    lazy var LineView : UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        return view
    }()
    
    @objc func showOption(){
        Deleget?.showOptionS()
    }
    
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImage)
        addSubview(userNameLbl)
        addSubview(optionButton)
        addSubview(timaCreationLbl)
        addSubview(followBtn)
        addSubview(VideoView)
        addSubview(LineView)
        self.cornerRadius = 25
        self.clipsToBounds = true
        
        
        backgroundColor = .white
        profileImage.anchor(top: topAnchor, bottom: nil , left: leftAnchor, right: nil, padingTop: 20, padingBotton: 0, padingLeft: 18, padingRight: 0, width: 40, height: 40)
        profileImage.layer.cornerRadius = 40 / 2
        
        userNameLbl.anchor(top: profileImage.topAnchor, bottom: nil, left: profileImage.rightAnchor, right: optionButton.leftAnchor, padingTop: 0, padingBotton: 0, padingLeft: 8, padingRight: 0, width: 0, height: 0)
        
        timaCreationLbl.anchor(top:  userNameLbl.bottomAnchor, bottom: profileImage.bottomAnchor, left: profileImage.rightAnchor, right: optionButton.leftAnchor, padingTop: 5, padingBotton: 0, padingLeft: 8, padingRight: 0, width: 0, height: 0)
        
        optionButton.anchor(top: topAnchor, bottom: profileImage.bottomAnchor, left: nil, right: rightAnchor, padingTop: 0, padingBotton: 0, padingLeft: 0, padingRight: 0, width: 44, height: 0)
        
        followBtn.anchor(top: topAnchor, bottom: nil, left: nil, right: optionButton.leftAnchor, padingTop: 20, padingBotton: 0, padingLeft: 0, padingRight: 0 , width: 100 , height: 20)
        
        VideoView.anchor(top: profileImage.bottomAnchor, bottom: nil, left: profileImage.leftAnchor, right: optionButton.rightAnchor, padingTop: 20, padingBotton: 0, padingLeft: 10, padingRight: -20, width: 0, height: 600)
        
        LineView.anchor(top: VideoView.bottomAnchor, bottom : nil , left: VideoView.leftAnchor, right: VideoView.rightAnchor, padingTop: 20, padingBotton: 0, padingLeft: 0, padingRight: 0, width: 0, height: 1)
        setUpActionButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpActionButton(){
        let stackView = UIStackView(arrangedSubviews: [likeButton,commetBtn,shareBtn])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: LineView.bottomAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, padingTop: 12, padingBotton: 20, padingLeft: 20, padingRight: -20, width: 0, height: 0)
    }
    
}



