//
//  UserFeedController.swift
//  ReputationApp
//
//  Created by Omar Torres on 17/10/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

private let reuseIdentifier = "Cell"

class UserFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let userFeedCell = "userFeedCell"
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? UserFeedLayout {
            layout.delegate = self
        }
        
        collectionView?.backgroundColor = .white
        tabBarController?.tabBar.isHidden = false
        
        collectionView?.register(UserFeedCell.self, forCellWithReuseIdentifier: userFeedCell)
        getAllAvents()
    }
    
    let url = URL(string: "https://protected-anchorage-18127.herokuapp.com/api/all_events")!
    
    func getAllAvents() {
        
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("the current user token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            Alamofire.request(url, headers: header).responseJSON { response in
                
                print("request: \(response.request!)") // original URL request
                print("response: \(response.response!)") // URL response
                print("response data: \(response.data!)") // server data
                print("result: \(response.result)") // result of response serialization
                
                if let JSON = response.result.value as? [[String: Any]] {
                    print("ALLEVENTSJSON: \(JSON)")
                    
                    for item in JSON {
                        let event_url = item["event_url"] as! String
                        var image = UIImage()
                        let imageURL = URL(string: event_url)
                        
                        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                        
                            do {
                                let imageData = try Data(contentsOf: imageURL!)
                                DispatchQueue.main.async(execute: {() -> Void in
                                    
                                    image = UIImage(data: imageData)!
                                    self.images.append(image)
                                    
                                    self.collectionView?.reloadData()
                                    
                            })
                            } catch {
                                print(error)
                            }
                        })
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userFeedCell, for: indexPath) as! UserFeedCell
 
        cell.photoImageView.image = self.images[indexPath.item]
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }

}

extension UserFeedController : UserFeedLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return images[indexPath.item].size.height
    }
    
}


