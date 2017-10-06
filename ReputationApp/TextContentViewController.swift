//
//  TextContentViewController.swift
//  ReputationApp
//
//  Created by Omar Torres on 5/10/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

class TextContentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var backButton: UIButton!
    
    let writeTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        tv.autocorrectionType = .no
        tv.textContainerInset = UIEdgeInsetsMake(10, 7, 5, 0)
        return tv
    }()
    
    let placeholderLabel: UILabel = {
        let pl = UILabel()
        pl.text = "Comienza a escribir tu reseña aquí..."
        pl.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        pl.sizeToFit()
        pl.frame.origin = CGPoint(x: 10, y: 10)
        pl.textColor = UIColor.lightGray
        return pl
    }()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Others configurations
//        writeTextView.becomeFirstResponder()
        self.writeTextView.delegate = self

        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        view.addSubview(topSeparatorView)
        topSeparatorView.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)

        view.addSubview(writeTextView)
        writeTextView.anchor(top: topSeparatorView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        writeTextView.addSubview(placeholderLabel)
        placeholderLabel.isHidden = !writeTextView.text.isEmpty
        
        view.addSubview(sendButton)
        sendButton.anchor(top: writeTextView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 20, height: 20)
        sendButton.addTarget(self, action: #selector(sendEvent), for: .touchUpInside)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        let isFormValid = writeTextView.text?.characters.count ?? 0 > 10
        
        if isFormValid {
            sendButton.isEnabled = true
            sendButton.backgroundColor = .red
//            keyboardToolbar.barTintColor = .mainBlue()
        } else {
            sendButton.isEnabled = false
            sendButton.backgroundColor = .black
//            keyboardToolbar.barTintColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    func sendEvent() {
        
        // Retreieve Auth_Token from Keychain
        if let userToken = Locksmith.loadDataForUserAccount(userAccount: "AuthToken") {
            
            let authToken = userToken["authenticationToken"] as! String
            
            print("the current user token: \(userToken)")
            
            guard let eventText = writeTextView.text else { return }
            
            // Set Authorization header
            let header = ["Authorization": "Token token=\(authToken)"]
            
            let parameters = ["description": eventText] as [String : Any]
            
            let url = URL(string: "https://protected-anchorage-18127.herokuapp.com/api/writeEvent")!
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseString(completionHandler: { (response) in
                print("This is the response: ", response)
            })

        }
    }
    
}
