//
//  UserRankingController.swift
//  ReputationApp
//
//  Created by Omar Torres on 26/05/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit
import Locksmith

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

class UserRankingController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .red
        
        navigationController?.navigationBar.barTintColor = UIColor.mainGreen()
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        collectionView?.alwaysBounceVertical = false
        collectionView?.keyboardDismissMode = .onDrag
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        guard let font = UIFont(name: "SFUIDisplay-Medium", size: 18) else { return }
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "Ranking de reputación"
    }
    
    func handleLogout() {
        clearLoggedinFlagInUserDefaults()
        clearAPITokensFromKeyChain()
        
        DispatchQueue.main.async {
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    // 1. Clears the NSUserDefaults flag
    func clearLoggedinFlagInUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
    
    // 3. Clears API Auth token from Keychain
    func clearAPITokensFromKeyChain() {
        // clear API Auth Token
        try! Locksmith.deleteDataForUserAccount(userAccount: "AuthToken")
        try! Locksmith.deleteDataForUserAccount(userAccount: "currentUserId")
    }
}
