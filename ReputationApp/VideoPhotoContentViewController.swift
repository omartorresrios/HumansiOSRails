//
//  VideoPhotoContentViewController.swift
//  ReputationApp
//
//  Created by Omar Torres on 5/10/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPhotoContentViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate, AVCaptureFileOutputRecordingDelegate, UIGestureRecognizerDelegate {
    
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
    
    let captureVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dot"), for: .normal)
        
        return button
    }()
    
    let stopRecording: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("jaja", for: .normal)
        button.addTarget(self, action: #selector(handleStopRecording), for: .touchUpInside)
        return button
    }()
    
    func handleStopRecording() {
        videoFileOutput.stopRecording()
        print("stop recording")
    }

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
        
        view.addSubview(captureVideoButton)
        captureVideoButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        captureVideoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureVideoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleCaptureVideo))
//        longPressRecognizer.delegate = self
//        longPressRecognizer.minimumPressDuration = 1
//        view.addGestureRecognizer(longPressRecognizer)
//        captureVideoButton.addGestureRecognizer(longPressRecognizer)
        captureVideoButton.addTarget(self, action: #selector(handleCaptureVideo), for: .touchUpInside)
        
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        
        
        view.addSubview(stopRecording)
        stopRecording.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        stopRecording.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stopRecording.alpha = 0
        
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("FINISHED \(error)")
        // save video to camera roll
        if error == nil {
            
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        } else {
            print("this is the error: ", error)
        }
    }
    
    let videoFileOutput = AVCaptureMovieFileOutput()
    
    func handleCaptureVideo() {
        stopRecording.alpha = 1
        
        
        
//        captureSession.addOutput(videoFileOutput)
//        
//        captureSession.startRunning()

        let recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self
        
        self.captureSession.addOutput(videoFileOutput)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("video").appendingPathExtension("mov")
        try? FileManager.default.removeItem(at: fileUrl)
//        try? FileManager.default.removeItem(at: fileUrl)
        videoFileOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: recordingDelegate)

//        if sender.state == UIGestureRecognizerState.ended {
//            print("stopping")
////            self.videoFileOutput.stopRecording({ videoFileOutput, fileUrl, error) in
////                if error == nil {
////                    let video = videovie
////                }
//        }
        
//        let delayTime = DispatchTime.now() + 5
//        DispatchQueue.main.asyncAfter(deadline: delayTime) {
//            print("stopping")
//            self.videoFileOutput.stopRecording()
//        }
        
        
        
        
        
        
//        let recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self
//        
//        self.captureSession.addOutput(videoFileOutput)
//        
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let fileUrl = paths[0].appendingPathComponent("output.mov")
////        try? FileManager.default.removeItem(at: fileUrl)
//        videoFileOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: recordingDelegate)
        
        
        
        
        
        
//        let recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self
//        
//        let videoFileOutput = AVCaptureMovieFileOutput()
//        self.captureSession.addOutput(videoFileOutput)
//        
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let filePath = documentsURL.appendingPathComponent("temp")
//        
//        videoFileOutput.startRecording(toOutputFileURL: filePath, recordingDelegate: recordingDelegate)
//        
        
        
////        let fileName = "mysavefile.mp4";
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let filePath = documentsURL.appendingPathComponent("temp")
//        
////        captureSession.sessionPreset = AVCaptureSessionPresetHigh
//        
//        
//        let videoFileOutput = AVCaptureMovieFileOutput()
//        
//        captureSession.addOutput(videoFileOutput)
//        
//        let recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self
//        videoFileOutput.startRecording(toOutputFileURL: filePath, recordingDelegate: recordingDelegate)
        

        
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
    

}
