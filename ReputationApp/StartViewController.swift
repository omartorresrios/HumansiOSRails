//
//  StartViewController.swift
//  ReputationApp
//
//  Created by Omar Torres on 3/10/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var videoPhotoButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    
    @IBOutlet weak var moreButton: UIButton!
    
    var videoPhotoButtonCenter: CGPoint!
    var photoLibraryButtonCenter: CGPoint!
    var textButtonCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        videoPhotoButtonCenter = videoPhotoButton.center
        photoLibraryButtonCenter = photoLibraryButton.center
        textButtonCenter = textButton.center
        
        videoPhotoButton.center = moreButton.center
        photoLibraryButton.center = moreButton.center
        textButton.center = moreButton.center
        
    }
    
    @IBAction func moreOptions(_ sender: UIButton) {
        if moreButton.currentImage == #imageLiteral(resourceName: "more_off") {
            // Expand buttons
            UIView.animate(withDuration: 0.3, animations: {
                self.videoPhotoButton.alpha = 1
                self.photoLibraryButton.alpha = 1
                self.textButton.alpha = 1
                
                // Animations here!
                self.videoPhotoButton.center = self.videoPhotoButtonCenter
                self.photoLibraryButton.center = self.photoLibraryButtonCenter
                self.textButton.center = self.textButtonCenter
            })
            
        } else {
            // Collapse buttons
            UIView.animate(withDuration: 0.3, animations: {
                self.videoPhotoButton.alpha = 0
                self.photoLibraryButton.alpha = 0
                self.textButton.alpha = 0
                
                self.videoPhotoButton.center = self.moreButton.center
                self.photoLibraryButton.center = self.moreButton.center
                self.textButton.center = self.moreButton.center
            })
            
        }
        
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "more_on"), offImage: #imageLiteral(resourceName: "more_off"))
    }
    
    @IBAction func photoLibraryClicked(_ sender: UIButton) {
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "photoLibraryOn"), offImage: #imageLiteral(resourceName: "photoLibraryOff"))
        
        let layout = UICollectionViewFlowLayout()
        let photoLibraryView = PhotoLibraryViewController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: photoLibraryView)
        
        present(navController, animated: true, completion: nil)
        
    }
    
    @IBAction func textClicked(_ sender: UIButton) {
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "textOn"), offImage: #imageLiteral(resourceName: "textOff"))
    }
    
    @IBAction func videoPhotoClicked(_ sender: UIButton) {
        toggleButton(button: sender, onImage: #imageLiteral(resourceName: "videoPhotoOn"), offImage: #imageLiteral(resourceName: "videoPhotoOff"))
        
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
        
    }
    
    func toggleButton(button: UIButton, onImage: UIImage, offImage: UIImage) {
        if button.currentImage == offImage {
            button.setImage(onImage, for: .normal)
        } else {
            button.setImage(offImage, for: .normal)
        }
    }
}
