//
//  MyProfileController.swift
//  ReputationApp
//
//  Created by Omar Torres on 25/10/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

private let reuseIdentifier = "Cell"

class MyProfileController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView!
    let cellId = "cellId"
    
    let storiesOptionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Momentos", for: .normal)
        button.addTarget(self, action: #selector(showUserStoriesView), for: .touchUpInside)
        button.layer.cornerRadius = 25
        return button
    }()
    
    let reviewsOptionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Reseñas", for: .normal)
        button.addTarget(self, action: #selector(showUserReviewsView), for: .touchUpInside)
        button.layer.cornerRadius = 25
        return button
    }()
    
    func showUserReviewsView() {
        let userReviewsController = UserReviewsController(collectionViewLayout: UICollectionViewFlowLayout())
        present(userReviewsController, animated: true, completion: nil)
    }
    
    func showUserStoriesView() {
        let userStoriesController = UserStoriesController(collectionViewLayout: UICollectionViewFlowLayout())
        present(userStoriesController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyProfileCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .yellow
        self.view.addSubview(collectionView)

        if let userName = Locksmith.loadDataForUserAccount(userAccount: "currentUserName") {
            print("the name of the user in this profile: ", userName)
            self.navigationItem.title = (userName as [String : AnyObject])["name"] as! String?
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogout))
    
        setupOptionsButtons()
        
//        loadEvents()
    }

    fileprivate func setupOptionsButtons() {
        let stackView = UIStackView(arrangedSubviews: [storiesOptionButton, reviewsOptionButton])
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.backgroundColor = .black
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyProfileCell
    
        return cell
    }
    
    func loadEvents() {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("Token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            print("THE HEADER: \(header)")
            
            Alamofire.request("https://protected-anchorage-18127.herokuapp.com/api/events", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                    print("THE EVENTS: \(JSON)")
                    
                case .failure(let error):
                    print("Some error ocurred:", error)
                }
            }
        }
        
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
        try! Locksmith.deleteDataForUserAccount(userAccount: "currentUserName")
    }
}
