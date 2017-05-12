//
//  LoginController.swift
//  ReputationApp
//
//  Created by Omar Torres on 10/05/17.
//  Copyright © 2017 OmarTorres. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    let httpHelper = HTTPHelper()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    func handleLoginRegister() {
        if loginRegisterSegmentedController.selectedSegmentIndex == 0 {
            signinBtnTapped()
        } else {
            signupBtnTapped()
        }
    }
    
    func signinBtnTapped() {
        // validate presence of all required parameters
        if (self.emailTextField.text?.characters.count)! > 0 && (self.passwordTextField.text?.characters.count)! > 0 {
            makeSignInRequest(userEmail: self.emailTextField.text!, userPassword: self.passwordTextField.text!)
        } else {
            self.displayAlertMessage("Parameters Required",
                                     alertDescription: "Some of the required parameters are missing")
        }
    }
    
    
    
    let fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "FullName"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let fullNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let userNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pio")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var loginRegisterSegmentedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedController.titleForSegment(at: loginRegisterSegmentedController.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //Change height of inputContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 100 : 150
        
        // Change height of fullNameTextField
        fullNameTextFieldHeightAnchor?.isActive = false
        fullNameTextFieldHeightAnchor = fullNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 0 : 1/4)
        fullNameTextFieldHeightAnchor?.isActive = true
        
        // Change height of userNameTextField
        userNameTextFieldHeightAnchor?.isActive = false
        userNameTextFieldHeightAnchor = userNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 0 : 1/4)
        userNameTextFieldHeightAnchor?.isActive = true
        
        // Change height of emailNameTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Change height of passwordNameTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedController)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLoginRegisterSegmentedControl() {
        // need x, y, width, height contstraints
        loginRegisterSegmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedController.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedController.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedController.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupProfileImageView() {
        // need x, y, width, height contstraints
        if #available(iOS 9.0, *) {
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        if #available(iOS 9.0, *) {
            profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedController.topAnchor, constant: -12).isActive = true
        }
        if #available(iOS 9.0, *) {
            profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        }
        if #available(iOS 9.0, *) {
            profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var fullNameTextFieldHeightAnchor: NSLayoutConstraint?
    var userNameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    func setupInputsContainerView() {
        // need x, y, width, height contstraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        
        inputsContainerView.addSubview(fullNameTextField)
        inputsContainerView.addSubview(fullNameSeparatorView)
        inputsContainerView.addSubview(userNameTextField)
        inputsContainerView.addSubview(userNameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        
        // (fullNameTextField) need x, y, width, height contstraints
        fullNameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        fullNameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        fullNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        fullNameTextFieldHeightAnchor = fullNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        fullNameTextFieldHeightAnchor?.isActive = true
        
        // (fullNameSeparatorView) need x, y, width, height contstraints
        fullNameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        fullNameSeparatorView.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor).isActive = true
        fullNameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        fullNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // (userNameTextField) need x, y, width, height contstraints
        userNameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        userNameTextFieldHeightAnchor = userNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        userNameTextFieldHeightAnchor?.isActive = true
        
        // (userNameSeparatorView) need x, y, width, height contstraints
        userNameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        userNameSeparatorView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        userNameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        userNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // (emailTextField) need x, y, width, height contstraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        // (emailSeparatorViewneed) x, y, width, height contstraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // (passwordTextField) need x, y, width, height contstraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func setupLoginRegisterButton() {
        // need x, y, width, height contstraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func displayAlertMessage(_ alertTitle:String, alertDescription:String) -> Void {
        // hide activityIndicator view and display alert message
        let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
        errorAlert.show()
    }
    
    func signupBtnTapped() {
        // validate presence of all required parameters
        if (self.fullNameTextField.text?.characters.count)! > 0 && (self.userNameTextField.text?.characters.count)! > 0 && (self.emailTextField.text?.characters.count)! > 0
            && (self.passwordTextField.text?.characters.count)! > 0 {
            makeSignUpRequest(self.fullNameTextField.text!, userName: self.userNameTextField.text!, userEmail: self.emailTextField.text!,
                              userPassword: self.passwordTextField.text!)
        } else {
            self.displayAlertMessage("Parameters Required", alertDescription:
                "Some of the required parameters are missing")
        }
    }
    
    func updateUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        let defaults = UserDefaults.standard
        defaults.set("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
    func saveApiTokenInKeychain(tokenDict:NSDictionary) {
        // Store API AuthToken and AuthToken expiry date in KeyChain
        tokenDict.enumerateKeysAndObjects({ (dictKey, dictObj, stopBool) -> Void in
            let myKey = dictKey as! String
            let myObj = dictObj as! String
            
            if myKey == "api_authtoken" {
                KeychainAccess.setPassword(password: myObj, account: "Auth_Token", service: "KeyChainService")
            }
            
            if myKey == "authtoken_expiry" {
                KeychainAccess.setPassword(password: myObj, account: "Auth_Token_Expiry", service: "KeyChainService")
            }
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //Signin user
    func makeSignInRequest(userEmail:String, userPassword:String) {
        
        // Create HTTP request and set request Body
        let httpRequest = httpHelper.buildRequest(path: "users/signin", method: "POST",
                                                  authType: HTTPRequestAuthType.HTTPBasicAuth)
        
        let encrypted_password = AESCrypt.encrypt(userPassword, password: HTTPHelper.API_AUTH_PASSWORD)
        
        httpRequest.httpBody = "email=\(userEmail)&password=\(encrypted_password)".data(using: String.Encoding.utf8);
        
        // 4. Send the request
        
        URLSession.shared.dataTask(with: httpRequest as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error == nil {
                DispatchQueue.main.async {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
                        guard json != nil else {
                            print("Error while parsing")
                            return
                        }
                        
                        // Print out response string
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Response String = \(responseString!)")
                        
                        // Updatge userLoggedInFlag
                        self.updateUserLoggedInFlag()
                        
                        var stopBool : Bool
                        
                        // save API AuthToken and ExpiryDate in Keychain
                        self.saveApiTokenInKeychain(tokenDict: json)
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    } catch {
                        print("Caught an error: \(error)")
                    }
                }
                
                
                
            } else {
                print("error: \(error)")
            }
        }).resume()
        
    }
    
    // Signup user
    func makeSignUpRequest(_ fullName: String, userName:String, userEmail:String, userPassword:String) {
        
        // 1. Create HTTP request and set request header
        let httpRequest = httpHelper.buildRequest(path: "users/signup", method: "POST",
                                              authType: HTTPRequestAuthType.HTTPBasicAuth)
        
        // 2. Password is encrypted with the API key
        let encrypted_password = AESCrypt.encrypt(userPassword, password: HTTPHelper.API_AUTH_PASSWORD)
        
        // 3. Send the request Body
        httpRequest.httpBody = "fullname=\(fullName)&username=\(userName)&email=\(userEmail)&password=\(encrypted_password)".data(using: String.Encoding.utf8)
        
        // 4. Send the request
        URLSession.shared.dataTask(with: httpRequest as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error == nil {
                DispatchQueue.main.async {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        guard json != nil else {
                            print("Error while parsing")
                            return
                        }
                        
                        // Print out response string
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Response String = \(responseString!)")
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    } catch {
                        print("Caught an error: \(error)")
                    }
                }
            } else {
                print("error: \(error)")
            }
        }).resume()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

extension UIColor{
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
