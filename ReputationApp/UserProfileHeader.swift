//
//  UserProfileHeader.swift
//  ReputationApp
//
//  Created by Omar Torres on 31/05/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var user: User? {
        didSet {
            fullnameLabel.text = user?.fullname
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "fullname"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(profileImageView)
//        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
//        profileImageView.layer.cornerRadius = 80 / 2
//        profileImageView.clipsToBounds = true
//                
//        addSubview(fullnameLabel)
//        fullnameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

