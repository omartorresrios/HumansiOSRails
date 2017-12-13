//
//  UserStoriesController.swift
//  ReputationApp
//
//  Created by Omar Torres on 10/12/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire
import Haneke
import MediaPlayer
import SCRecorder
import SDWebImage
import ROThumbnailGenerator

class UserStoriesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var userId: Int?
    var userFullname: String?
    var userImageUrl: String?
    var currentUserDic = [String: Any]()
    var images: [NSURL] = []
    let userFeedCell = "userFeedCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white

        // Register cell classes
        collectionView?.register(UserFeedCell.self, forCellWithReuseIdentifier: userFeedCell)

        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(tapGesture)
        
        loadUserEvents()
        
    }
    
    func loadUserEvents() {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("Token: \(userToken)")
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            print("THE HEADER: \(header)")
            
            Alamofire.request("https://protected-anchorage-18127.herokuapp.com/api/\(userFullname!)/events", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON { response in
                
                print("request: \(response.request!)") // original URL request
                print("response: \(response.response!)") // URL response
                print("response data: \(response.data!)") // server data
                print("result: \(response.result)") // result of response serialization
                
                if let JSON = response.result.value as? [[String: Any]] {
                    print("\nTHE USER EVENTS: \(JSON)\n")
                    
                    for item in JSON {
                        
                        let event_url = item["event_url"] as! String
                        
                        print("\nevent_url: ", event_url)
                        
                        let endIndex = event_url.index(event_url.endIndex, offsetBy: -11)
                        let truncated = event_url.substring(to: endIndex)
                        
                        let cache = Shared.dataCache
                        let URL = NSURL(string: truncated)!
                        
                        cache.fetch(URL: URL as URL).onSuccess { (data) in
                            
                            let path = NSURL(string: DiskCache.basePath())!.appendingPathComponent("shared-data/original")
                            let cached = DiskCache(path: (path?.absoluteString)!).path(forKey: String(describing: URL))
                            let file = NSURL(fileURLWithPath: cached)
                            
                            self.images.append(file)
                            self.collectionView?.reloadData()
                            
                            
                        }
                        
                        
                        
                        
//                        let cache = Cache<JSON>(name: "amazonaws")
////                        let URL = NSURL(string: event_url)!
//
//                        let endIndex = event_url.index(event_url.endIndex, offsetBy: -11)
//                        let truncated = event_url.substring(to: endIndex)
////                        print("new url thumb: ", truncated)
//
//                        cache.fetch(URL: URL(string: truncated)!).onSuccess { jsonResult in
//                            print("A verrr: ", jsonResult)
//                        }
                        
                    }
                }
            }
        }
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userFeedCell, for: indexPath) as! UserFeedCell
    
       
        
        let image = self.images[indexPath.item]
//        print("IMAGE: ", image)
        
        let thumbnailImage = ROThumbnail.sharedInstance.getThumbnail(image as URL)
        
        cell.photoImageView.image = thumbnailImage
        
//        DispatchQueue.global().async {
//            let asset = AVAsset(url: image as URL)
//            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
//            assetImgGenerate.appliesPreferredTrackTransform = true
//            let time = CMTimeMake(1, 2)
//            let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
//            if img != nil {
//                let frameImg  = UIImage(cgImage: img!)
//                DispatchQueue.main.async(execute: {
//                    cell.photoImageView.image = frameImg
//                })
//            }
//        }
        
//        // so lets play the video
//        let player: SCPlayer = SCPlayer()
//        player.setItemBy(image as URL)
//        let layer = AVPlayerLayer(player: player)
//        layer.frame = cell.bounds//self.view.bounds
//        cell.layer.addSublayer(layer) // this is my view
//        player.play()
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

}
