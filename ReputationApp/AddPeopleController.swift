//
//  AddPeopleController.swift
//  ReputationApp
//
//  Created by Omar Torres on 30/07/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit

class AddPeopleController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = true
        
        collectionView?.backgroundColor = .yellow
        
        
    }
}
