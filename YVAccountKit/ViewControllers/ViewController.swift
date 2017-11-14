//
//  ViewController.swift
//  YVAccountKit
//
//  Created by Yash Vyas on 14/11/17.
//  Copyright © 2017 Yash Vyas. All rights reserved.
//

import UIKit
import AccountKit

class ViewController: UIViewController {

    @IBOutlet weak var btnEmailLogin: UIButton!
    @IBOutlet weak var btnPhoneLogin: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    var _accountKit: AKFAccountKit?
    var _pendingLoginViewController: AKFViewController?
    
    var bicycleTheme: AKFTheme {
        let theme = AKFTheme(primaryColor: UIColor.colorWithHex(0xffff5a5f), primaryTextColor: .white, secondaryColor: .white, secondaryTextColor: .white, statusBarStyle: .lightContent)
        theme.backgroundImage = UIImage(named: "bicycle")
        theme.backgroundColor = UIColor.colorWithHex(0x66000000)
        theme.inputBackgroundColor = UIColor.colorWithHex(0x00000000)
        theme.inputBorderColor = .white
        return theme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnEmailLogin.layer.borderWidth = 0.5
        btnPhoneLogin.layer.borderWidth = 0.5
        btnLogout.layer.borderWidth = 0.5
        
        btnEmailLogin.layer.borderColor = UIColor.blue.cgColor
        btnPhoneLogin.layer.borderColor = UIColor.blue.cgColor
        btnLogout.layer.borderColor = UIColor.red.cgColor
        
        // initialize Account Kit
        if (_accountKit == nil) {
            // may also specify AKFResponseTypeAccessToken
            _accountKit = AKFAccountKit(responseType: .accessToken)
        }
        
        // view controller for resuming login
        _pendingLoginViewController = _accountKit?.viewControllerForLoginResume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.isUserLoggedIn()) {
            // if the user is already logged in, go to the main screen
            self.proceedToMainScreen()
        } else if let pendingLoginViewController = _pendingLoginViewController {
            // resume pending login (if any)
            _prepareLoginViewController(pendingLoginViewController)
            present(pendingLoginViewController as! UIViewController, animated: true, completion: nil)
        } else {
            btnLogout.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Methods
    
    func isUserLoggedIn() -> Bool {
        return _accountKit?.currentAccessToken != nil
    }
    
    func _prepareLoginViewController(_ loginViewController: AKFViewController) {
        loginViewController.delegate = self
        // Optionally, you may use the Advanced UI Manager or set a theme to customize the UI.
        //loginViewController.advancedUIManager = _advancedUIManager
        loginViewController.setTheme(bicycleTheme)
    }
    
    func proceedToMainScreen() {
        // Show your next screen.
        
        btnEmailLogin.isHidden = true
        btnPhoneLogin.isHidden = true
        btnLogout.isHidden = false
        
        self.alert("Login successful.")
    }
    
    @IBAction func logout() {
        _accountKit?.logOut({ (status, error) in
            if status == true {
                self.alert("User logged out successfully.")
                
                self.btnPhoneLogin.isHidden = false
                self.btnEmailLogin.isHidden = false
                self.btnLogout.isHidden = true
                
            } else if let error = error {
                self.alert(error.localizedDescription)
            }
        })
    }

    @IBAction func loginWithPhone(_ sender: AnyObject?) {
        let preFillPhoneNumber: AKFPhoneNumber? = nil
        let inputState = UUID().uuidString
        if let viewController = _accountKit?.viewControllerForPhoneLogin(with: preFillPhoneNumber, state: inputState) {
            viewController.enableSendToFacebook = true // defaults to NO
            _prepareLoginViewController(viewController) // see below
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginWithEmail(_ sender: AnyObject?) {
        let preFillEmailAddress: String? = nil
        let inputState = UUID().uuidString
        if let viewController = _accountKit?.viewControllerForEmailLogin(withEmail: preFillEmailAddress, state: inputState) {
            viewController.enableSendToFacebook = true // defaults to NO
            _prepareLoginViewController(viewController) // see below
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
}

extension ViewController: AKFViewControllerDelegate {
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
        debugPrint(accessToken)
        debugPrint(state)
        
        self._accountKit?.requestAccount({ (account, error) in
            if error == nil {
                if account != nil {
                    print(account!.accountID)
                    print(account!.emailAddress ?? "Email not found.")
                    print(account!.phoneNumber?.stringRepresentation() ?? "Phone number not found.")
                } else {
                    print("Account not found.")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        self.proceedToMainScreen()
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        // Pass the code to your own server and have your server exchange it for a user access token.
        // You should wait until you receive a response from your server before proceeding to the main screen.
        
        debugPrint(code)
        debugPrint(state)
        
        self.proceedToMainScreen()
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        // ... implement appropriate error handling ...
        print(error.localizedDescription)
    }
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        // ... handle user cancellation of the login process ...
    }
}
