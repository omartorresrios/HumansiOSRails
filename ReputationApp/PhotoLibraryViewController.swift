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
    let videoHeaderId = "videoHeaderId"
    
    var selectedImage: UIImage?
    var selectedVideo: UIImage?
    var images = [UIImage]()
    var videos = [UIImage]()
    var assets = [PHAsset]()
    var videoAssets = [PHAsset]()
    
    let items = ["Fotos", "Videos"]
    var customSC = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingTop = (navigationController?.navigationBar.frame.size.height)!
        
        customSC = UISegmentedControl(items: items)
        
        customSC.selectedSegmentIndex = 0
        view.addSubview(customSC)
        customSC.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: paddingTop, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        // Add target action method
        customSC.addTarget(self, action: #selector(changeView(sender:)), for: .valueChanged)
        
        collectionView?.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 29	, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        collectionView?.backgroundColor = .white
        
        setupNavigationButtons()
        
        collectionView?.register(PhotoLibraryContentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(PhotoLibraryContentHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(VideoLibraryContentHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: videoHeaderId)
        
        fetchPhotosAndVideos()
    }
    
    func changeView(sender: UISegmentedControl) {
        print("changing")
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if customSC.selectedSegmentIndex == 0 {
            self.selectedImage = images[indexPath.item]
        } else {
            self.selectedVideo = videos[indexPath.item]
        }
        
        self.collectionView?.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    fileprivate func fetchPhotosAndVideos() {
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        let allVideos = PHAsset.fetchAssets(with: .video, options: self.assetsFetchOptions())
        
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
            
            
            allVideos.enumerateObjects({ (asset, count, stop) in
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestAVAsset(forVideo: asset, options: .none) { (avAsset, avAudioMix, dict) -> Void in
                    if avAsset != nil {
                        let url = avAsset?.value(forKeyPath: "URL")
                        print("Just url: ", url!)
                        
                                                self.videoUrls.append(url as! URL)
                        //                        self.assets.append(asset)
//                                                self.finalArray.append(self.videoUrls as NSObject)
                        
                        self.previewUrl = url as? URL
                        print("List of previewUrls inside: ", self.previewUrl)
                    }
                }
                
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    
                    if let image = image {
                        self.videos.append(image)
                        self.videoAssets.append(asset)
                        
                        if self.selectedVideo == nil {
                            self.selectedVideo = image
                        }
                    }
                    
                    if count == allVideos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                })
            })
            print("List of previewUrls outside: ", self.previewUrl)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func playVideo(header: UICollectionViewCell, url: URL) {
        let videoURL = URL(string: (url.absoluteString))
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = header.contentView.bounds
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        header.layer.addSublayer(playerLayer)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                player.seek(to: kCMTimeZero)
                player.play()
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if customSC.selectedSegmentIndex == 0 {
            
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
            
        } else {
            
            let videoHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: videoHeaderId, for: indexPath) as! VideoLibraryContentHeader
            
            videoHeader.photoImageView.image = selectedVideo
            
            if let selectedVideo = selectedVideo {
                if let index = self.videos.index(of: selectedVideo) {
                    let selectedAsset = self.videoAssets[index]
                    
                    let imageManager = PHImageManager.default()
                    let targetSize = CGSize(width: 600, height: 600)
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                            
                            videoHeader.photoImageView.image = image
                            
                            imageManager.requestAVAsset(forVideo: selectedAsset, options: .none) { (avAsset, avAudioMix, dict) -> Void in
                                if avAsset != nil {
                                    let url = avAsset?.value(forKeyPath: "URL") as! URL
                                    
                                    self.playVideo(header: videoHeader, url: url)
                                    
                                }
                            }
                            
                        })
                        
                    }
                    
                }
            }
            
            return videoHeader
        }
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
        if customSC.selectedSegmentIndex == 0 {
            return images.count
        } else {
            return videos.count
        }
        //        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoLibraryContentCell
        
        if customSC.selectedSegmentIndex == 0 {
            cell.photoImageView.image = images[indexPath.item]
        } else {
            cell.photoImageView.image = videos[indexPath.item]
            
            
//            if let urlurl = previewUrl {
//                
//                let data = try? Data(contentsOf: urlurl)
//                let image: UIImage = UIImage(data: data!)!
                
//                if cell.photoImageView.image == image {
                
            
//                }
                
//            } else {
//                print("Impossible retrieve previewUrl")
//            }
        }
        
        
        
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
