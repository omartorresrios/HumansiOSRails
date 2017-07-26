//
//  UserSearchController.swift
//  ReputationApp
//
//  Created by Omar Torres on 26/05/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let httpHelper = HTTPHelper()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.fullname.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.collectionView?.reloadData()
        
    }
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)
        
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllUsers()
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        searchBar.isHidden = true
        searchBar.resignFirstResponder()

        let user = filteredUsers[indexPath.item]
        print(user.fullname)

        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userUsername = user.username
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    
    func loadAllUsers() {
        
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("Token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            print("THE HEADER: \(header)")
            
            Alamofire.request("https://protected-anchorage-18127.herokuapp.com/api/all_users", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let JSON):
                    print("THE JSON: \(JSON)")
                case .failure(let error):
                    print(error)
                }
            }
        }

        
        
        
        
        
        
        
        
//        let url = NSURL(string: GET_ALL_USERS)
//       
//        let httpRequest = NSMutableURLRequest(url: url as! URL)
//        
//        httpRequest.httpMethod = "GET"
//             
//        guard let token = AuthService.instance.authToken else { return }
//        
//        httpRequest.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
//        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        URLSession.shared.dataTask(with: httpRequest as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//        
//            if error != nil {
//                // Failure
//                print("URL Session Task Failed: \(error!.localizedDescription)")
//                return
//            }
//            
//            // Success
//            let statusCode = (response as! HTTPURLResponse).statusCode
//            print("URL Session Task Succeeded: HTTP \(statusCode)")
//            if statusCode != 200 {
//                // Failed
//                print("There's no a 200 status in UserSearchController. Failed")
//                return
//            }
//            
//            DispatchQueue.main.async {
//                do {
//                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
//                        print("this is the data: \(convertedJsonIntoDict)")
//                        let dataArray = convertedJsonIntoDict["users"] as! NSArray
//                        
//                        dataArray.forEach({ (value) in
//                            guard let userDictionary = value as? [String: Any] else { return }
//                            print("this is userDictionary: \(userDictionary)")
//                            let user = User(dictionary: userDictionary)
//                            self.users.append(user)
//                            
//                        })
//                        
//                        self.filteredUsers = self.users
//                        self.collectionView?.reloadData()
//                    }
//                    
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
//            }
//        }).resume()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        
        cell.user = filteredUsers[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    func handleLogout() {
        
        clearLoggedinFlagInUserDefaults()
        
        DispatchQueue.main.async {
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func clearLoggedinFlagInUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
}
