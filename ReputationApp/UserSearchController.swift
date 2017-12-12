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

class UserSearchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    let httpHelper = HTTPHelper()
    let cellId = "cellId"
    var filteredUsers = [User]()
    var users = [User]()
    var currentUserDic = [String: Any]()
    var collectionView: UICollectionView!
    var userSelected: User!
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Busca a alguien..."
        sb.setValue("Cancelar", forKey:"_cancelButtonText")
        sb.delegate = self
        return sb
    }()
    
    let loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.alpha = 1.0
        indicator.startAnimating()
        return indicator
    }()
    
    let messageLabel: UILabel = {
        let ml = UILabel()
        ml.font = UIFont.systemFont(ofSize: 12)
        ml.numberOfLines = 0
        ml.textAlignment = .center
        return ml
    }()
    
    let userInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let storiesOptionButton: UIButton = {
        let button = UIButton()
        button.setTitle("stories", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(showUserStoriesView), for: .touchUpInside)
        button.backgroundColor = .yellow
        return button
    }()

    let reviewsOptionButton: UIButton = {
        let button = UIButton()
        button.setTitle("reviews", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(showUserReviewsView), for: .touchUpInside)
        button.backgroundColor = .yellow
        return button
    }()

    let writeReviewOptionButton: UIButton = {
        let button = UIButton()
        button.setTitle("deja un review", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(showWriteReviewView), for: .touchUpInside)
        button.backgroundColor = .yellow
        return button
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.fullname.lowercased().contains(searchText.lowercased())
            }
        }
        
        // Check is there are results
        if filteredUsers.isEmpty {
            messageLabel.isHidden = false
            messageLabel.text = "🙁 No encontramos a esa persona."
        } else {
            messageLabel.isHidden = true
        }
        
        collectionView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        filteredUsers = users
        collectionView.reloadData()
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
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .brown
        self.view.addSubview(collectionView)
        
        // Reachability for checking internet connection
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
        // General properties of the view
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        navigationController?.navigationBar.addSubview(searchBar)
        navigationController?.navigationBar.barTintColor = UIColor.mainBlue()
        
//        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        
        // Customize search bar fonts and colors
        for subView: UIView in searchBar.subviews {
            for field: Any in subView.subviews {
                if (field is UITextField) {
                    let textField: UITextField? = (field as? UITextField)
                    textField?.backgroundColor = UIColor.clear
                }
            }
        }
        
        let attributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: "SFUIDisplay-Regular", size: 17)]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = .white
        textFieldInsideUISearchBar?.font = UIFont(name: "SFUIDisplay-Regular", size: 18)
        
        let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 18)
        placeholderLabel?.textColor = .white
        
        let glassIconView = textFieldInsideUISearchBar?.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = .white
        glassIconView.frame.size.width = 15
        glassIconView.frame.size.height = 15
        
        // Initialize the loader and position it
        collectionView.addSubview(loader)
//        let indicatorYStartPosition = (navigationController?.navigationBar.frame.size.height)! + 10
        loader.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 40)
        
        // Position the searchbar
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        // Position the messageLabel
        view.addSubview(messageLabel)
        messageLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Initialize functions
//        loadAllUsers()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // General properties of the view
        navigationController?.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.isStatusBarHidden = true
        searchBar.isHidden = false
        
        // Register customize cells
        collectionView.register(UserSearchHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "searchHeaderId")
        
    }
    
    func reachabilityStatusChanged() {
        print("Checking connectivity...")
    }
    
    func showUserStoriesView() {
        userInfoView.removeFromSuperview()
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()) // CAMABIRLE EL NOMBRE AL CONTROLLER
        
        userProfileController.userId = userSelected.id
        userProfileController.userFullname = userSelected.fullname
        userProfileController.userImageUrl = userSelected.profileImageUrl
        userProfileController.currentUserDic = currentUserDic
        
        present(userProfileController, animated: true, completion: nil)
    }
    
    func showUserReviewsView() {
        userInfoView.removeFromSuperview()
        
        let userReviewsController = UserReviewsController(collectionViewLayout: UICollectionViewFlowLayout())
        present(userReviewsController, animated: true, completion: nil)
    }
    
    func showWriteReviewView() {
        userInfoView.removeFromSuperview()
        
        let writeReviewController = WriteReviewController(collectionViewLayout: UICollectionViewFlowLayout())
        present(writeReviewController, animated: true, completion: nil)
    }

    func loadAllUsers() {
        // Check for internet connection
        if (reachability?.isReachable)! {
            
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
                        
                        let jsonArray = JSON as! NSDictionary
                        
                        let dataArray = jsonArray["users"] as! NSArray

                        dataArray.forEach({ (value) in
                            guard let userDictionary = value as? [String: Any] else { return }
                            print("this is userDictionary: \(userDictionary)")
                            
                            guard let userIdFromKeyChain = Locksmith.loadDataForUserAccount(userAccount: "currentUserId") else { return }
                            
                            let userId = userIdFromKeyChain["id"] as! Int
                            
                            if userDictionary["id"] as! Int == userId {
                                print("Found myself, omit from list")
                                self.currentUserDic = userDictionary
                                return
                            }
                            let user = User(uid: userDictionary["id"] as! Int, dictionary: userDictionary)
                            self.users.append(user)

                        })
                        
                        self.users.sort(by: { (u1, u2) -> Bool in
                            
                            return u1.fullname.compare(u2.fullname) == .orderedAscending
                            
                        })
                        
                        self.filteredUsers = self.users
                        self.collectionView.reloadData()
                        self.loader.stopAnimating()
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            self.loader.stopAnimating()
            
            let alert = UIAlertController(title: "Error", message: "Tu conexión a internet está fallando. 🤔 Intenta de nuevo.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let user = filteredUsers[indexPath.item]
        userSelected = user
        print("user selected: \(user.fullname)")
        
        view.addSubview(userInfoView)
        userInfoView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        userInfoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [storiesOptionButton, reviewsOptionButton, writeReviewOptionButton])
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        userInfoView.addSubview(stackView)
        stackView.anchor(top: userInfoView.topAnchor, left: userInfoView.leftAnchor, bottom: userInfoView.bottomAnchor, right: userInfoView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        
        cell.user = filteredUsers[indexPath.item]
        
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 32) / 3
        return CGSize(width: width, height: width + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "searchHeaderId", for: indexPath) as! UserSearchHeader
        header.backgroundColor = UIColor.mainBlue()
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 31)
    }
    
}
