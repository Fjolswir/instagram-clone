/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signUpMode = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var accountLabel: UILabel!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signUpOutlet: UIButton!
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet var changeSignModeOutlet: UIButton!
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            createAlert(title: "Error in form", message: "Please enter an email and password")
        
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            
            if signUpMode {
                
                // Sign Up
                
                let user = PFUser()
                
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later"
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.createAlert(title: "Signup Error", message: displayErrorMessage)
                        
                    } else {
                        
                        print("user signed up")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                })
            } else {
                
                // Login
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: {(user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later"
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.createAlert(title: "Login Error", message: displayErrorMessage)
                        
                    } else {
                        
                        print("logged in")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)

                        
                    }
                    
                })
                
            }
        }
    }
    
    
    @IBAction func changeSignModeBtn(_ sender: Any) {
        
        if signUpMode == true {
        
            signUpOutlet.setTitle("Log in!", for: [])
        
            changeSignModeOutlet.setTitle("Sign Up!", for: [])
            
            accountLabel.text = "New user?"
            
            signUpMode = false
        
        } else {
            
            signUpOutlet.setTitle("Sign up!", for: [])
            
            changeSignModeOutlet.setTitle("Log in!", for: [])
            
            accountLabel.text = "Already have an account?"
            
            signUpMode = true
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            performSegue(withIdentifier: "showUserTable", sender: self)
            
            self.navigationController?.navigationBar.isHidden = true
            
        }
        
    }
}
