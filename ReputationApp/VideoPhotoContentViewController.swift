//
//  VideoPhotoContentViewController.swift
//  ReputationApp
//
//  Created by Omar Torres on 5/10/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPhotoContentViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Atrás", for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dot"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self

        setupCaptureSession()
        
        setupHUD()
    }
    
    let customAnimationPresenter = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismisser()
    
    // Which camera input do we want tou use
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresenter
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    func handleCapturePhoto() {
        
        let settings = AVCapturePhotoSettings()
        
        guard let previewFormaTtype = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormaTtype]
        
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        
        let previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    let output = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    
    func setupCaptureSession() {
        
        //1. Setup inputs
        var captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
            if device.position == .back {
                backFacingCamera = device
            } else if device.position == .front {
                frontFacingCamera = device
            }
        }
        
        captureDevice = backFacingCamera
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not setup camera input:", err)
        }
        
        //2. Setup outputs
        
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //3. Setup output preview
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        // Switching between cameras (front and back)
        let toggleCameraGestureRecognizer = UITapGestureRecognizer()
        toggleCameraGestureRecognizer.numberOfTapsRequired = 2
        toggleCameraGestureRecognizer.addTarget(self, action: #selector(toggleCamera))
        
        view.addGestureRecognizer(toggleCameraGestureRecognizer)
        
    }
    
    func toggleCamera() {
        captureSession.beginConfiguration()
        
        let newDevice = (currentDevice?.position == .back) ? frontFacingCamera : backFacingCamera
        
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        let cameraInput: AVCaptureDeviceInput
        
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice    )
        } catch let error {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        captureSession.commitConfiguration()
    }
    

    func applicationDocumentsDirectory() -> NSURL {
        return FileManager.defaultManager.URLsForDirectory(FileManager.SearchPathDirectory.documentDirectory, inDomains: FileManager.SearchPathDomainMask.UserDomainMask).last
    }
    
}
