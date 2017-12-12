//
//  WriteReviewController.swift
//  ReputationApp
//
//  Created by Omar Torres on 10/12/17.
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
        collectionView?.backgroundColor = .cyan//UIColor.rgb(red: 247, green: 247, blue: 247)
//        navigationController?.navigationBar.barTintColor = .white
        
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(tapGesture)
        
        //        // Others configurations
        //        writeReviewTextView.becomeFirstResponder()
        //        self.writeReviewTextView.delegate = self
        
        // Initialize functions
        //        subviewsAnchors()
        
        // Reachability for checking internet connection
        //        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
    }
    
    // define a variable to store initial touch position
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}
