//
//  WriteReviewController.swift
//  ReputationApp
//
//  Created by Omar Torres on 30/07/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit
import JDStatusBarNotification

class WriteReviewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    var userReceiverId: String?
    
    var userReceiverFullname: String?
    
    var userReceiverImageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // General properties of the view
        collectionView?.backgroundColor = UIColor.rgb(red: 247, green: 247, blue: 247)
        navigationController?.navigationBar.barTintColor = .white
        
//        // Others configurations
//        writeReviewTextView.becomeFirstResponder()
//        self.writeReviewTextView.delegate = self
        
        // Initialize functions
//        subviewsAnchors()
        
        // Reachability for checking internet connection
//        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
    }
}
