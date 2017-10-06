//
//  MainTabBarController.swift
//  ReputationApp
//
//  Created by Omar Torres on 26/05/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
            
        let index = viewControllers?.index(of: viewController)
        if index == 1 {
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let startViewController = mainStoryboard.instantiateViewController(withIdentifier: "StartView")
            
            present(startViewController, animated: true, completion: nil)

            
            return false
        }
            
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isStatusBarHidden = false
        
        tabBar.isHidden = true
        
        self.delegate = self
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "userLoggedIn") == nil {
            //show if not logged in
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
        }
        
        setupViewControllers { (success) in
            print("setup success")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBar.isHidden = false
    }
    
    func setupViewControllers(completion: @escaping _Callback) {
        
        //search
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "gear"), selectedImage: #imageLiteral(resourceName: "dot"))
        
        
        //user ranking
        let layout = UICollectionViewFlowLayout()
        let userRankingController = UserRankingController(collectionViewLayout: layout)
        
        let userRankingNavController = UINavigationController(rootViewController: userRankingController)
        
        userRankingNavController.tabBarItem.image = #imageLiteral(resourceName: "ranking_unselected")
        userRankingNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "ranking_selected")
        
        tabBar.tintColor = UIColor.mainBlue()
        
        viewControllers = [searchNavController, plusNavController, userRankingNavController]
        
        completion(true)
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
