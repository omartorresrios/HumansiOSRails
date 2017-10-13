//
//  photoLibraryViewController.swift
//  ReputationApp
//
//  Created by Omar Torres on 5/10/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import Locksmith

class PhotoLibraryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        setupNavigationButtons()
        
        collectionView?.register(PhotoLibraryContentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(PhotoLibraryContentHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        fetchPhotos()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        self.collectionView?.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    var selectedImage: UIImage?
    var images = [UIImage]()
    var assets = [PHAsset]()
    
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    fileprivate func fetchPhotos() {
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects({ (asset, count, stop) in
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                    
                })
                
            })
        }
        
        //        let allVideos = PHAsset.fetchAssets(with: .video, options: self.assetsFetchOptions())
        //
        //        allVideos.enumerateObjects({ (asset, count, stop) in
        //
        //            let imageManager = PHImageManager.default()
        //            let targetSize = CGSize(width: 200, height: 200)
        //            let options = PHImageRequestOptions()
        //            options.isSynchronous = true
        //
        //            imageManager.requestAVAsset(forVideo: asset, options: .none) { (avAsset, avAudioMix, dict) -> Void in
        //                if avAsset != nil {
        //                    let url = avAsset?.value(forKeyPath: "URL")
        //                    print("Just url: ", url!)
        //
        //                    //                        self.videoUrls.append(url as! URL)
        //                    //                        self.assets.append(asset)
        //                    //                        self.finalArray.append(self.videoUrls as NSObject)
        //
        //                    self.previewUrl = url as? URL
        //                    print("List of previewUrls inside: ", self.previewUrl)
        //                }
        //            }
        //
        //
        //            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
        //
        //                if let image = image {
        //                    self.images.append(image)
        //                    self.assets.append(asset)
        //
        //                    if self.selectedImage == nil {
        //                        self.selectedImage = image
        //                    }
        //                }
        //
        //                if count == allVideos.count - 1 {
        //                    DispatchQueue.main.async {
        //                        self.collectionView?.reloadData()
        //                    }
        //                }
        //            })
        //        })
        //        print("List of previewUrls outside: ", self.previewUrl)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoLibraryContentHeader
        
        header.photoImageView.image = selectedImage
        
        if let selectedImage = selectedImage {
            if let index = self.images.index(of: selectedImage) {
                let selectedAsset = self.assets[index]
        
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                DispatchQueue.global(qos: .background).async {
                    
                    imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                        
                        header.photoImageView.image = image
                        
                    })
                    
                }
                
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoLibraryContentCell
        
        cell.photoImageView.image = images[indexPath.item]
        
        //        cell.photoImageView.image = images[indexPath.item]
        //
        //        var arrayOfVideosInImages = [UIImage]()
        //
        //        print("List of videoUrls: ", self.videoUrls)
        //        for urlItem in self.videoUrls {
        //            let data = try? Data(contentsOf: urlItem)
        //            let image: UIImage = UIImage(data: data!)!
        //            arrayOfVideosInImages.append(image)
        //        }
        //
        //        print("Lis of images based on its videoUrls: ", arrayOfVideosInImages)
        
        //        for object in arrayOfVideosInImages {
        //            if cell.photoImageView.image == object {
        //
        //                print("Coincidió!")
        ////                let videoURL = URL(string: (previewUrl?.absoluteString)!)
        ////                let player = AVPlayer(url: videoURL!)
        ////                let playerLayer = AVPlayerLayer(player: player)
        ////                playerLayer.frame = cell.contentView.bounds//cell.contentView.bounds//self.view.bounds
        ////                playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        ////                cell.layer.addSublayer(playerLayer)//self.view.layer.addSublayer(playerLayer)
        ////                player.play()
        ////
        ////                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil, using: { (_) in
        ////                    DispatchQueue.main.async {
        ////                        player.seek(to: kCMTimeZero)
        ////                        player.play()
        ////                    }
        ////                })
        //            }
        //        }
        
        //        if let urlurl = previewUrl {
        //
        //            let data = try? Data(contentsOf: urlurl)
        //            let image: UIImage = UIImage(data: data!)!
        //
        //            if cell.photoImageView.image == image {
        //
        //                let videoURL = URL(string: (previewUrl?.absoluteString)!)
        //                let player = AVPlayer(url: videoURL!)
        //                let playerLayer = AVPlayerLayer(player: player)
        //                playerLayer.frame = cell.contentView.bounds//cell.contentView.bounds//self.view.bounds
        //                playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        //                cell.layer.addSublayer(playerLayer)//self.view.layer.addSublayer(playerLayer)
        //                player.play()
        //
        //                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil, using: { (_) in
        //                    DispatchQueue.main.async {
        //                        player.seek(to: kCMTimeZero)
        //                        player.play()
        //                    }
        //                })
        //            }
        //            
        //        } else {
        //            print("Impossible retrieve previewUrl")
        //        }
        
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    let photoCaption: UITextView = {
        let tv = UITextView()
        return tv
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        return button
    }()
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleNext() {
        view.addSubview(photoCaption)
        photoCaption.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 100)
        photoCaption.alpha = 0
        
        view.addSubview(shareButton)
        shareButton.anchor(top: photoCaption.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 20, height: 20)
        
        shareButton.addTarget(self, action: #selector(sendEvent), for: .touchUpInside)
        
        shareButton.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.4, options: .curveEaseIn, animations: {
            
            self.photoCaption.alpha = 1
            self.shareButton.alpha = 1
            
        }) { (succes) in
            print("success")
        }
        
    }
    var previewUrl: URL?
    
    var videoUrls = [URL]()

    func sendEvent() {
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("the current user token: \(userToken)")
            
            guard let caption = photoCaption.text else { return }
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            let parameters = ["description": caption] as [String : Any]
            
            let url = URL(string: "https://protected-anchorage-18127.herokuapp.com/api/writeEvent")!
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                let pictureSelected = UIImageJPEGRepresentation(self.selectedImage!, 0.5)
                
                if let pictureData = pictureSelected {
                    multipartFormData.append(pictureData, withName: "picture", fileName: "picture.jpg", mimeType: "image/png")
                }
                
                for (key, value) in parameters {
                    multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            }, usingThreshold: UInt64.init() , to: url, method: .post, headers: header, encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        print("request: \(response.request!)") // original URL request
                        print("response: \(response.response!)") // URL response
                        print("response data: \(response.data!)") // server data
                        print("result: \(response.result)") // result of response serialization
                        
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        }
                    }
                    
                case .failure(let encodingError):
                    print("Alamofire proccess failed", encodingError)
                }
            })
            
        } else {
            print("Impossible retrieve token")
        }
        
    }
}
