//
//  LoginViewController.swift
//  BRSChat
//
//  Created by Bindu on 23/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var scrlContainer: UIScrollView!
    @IBOutlet var passwordTextField: XMTextField!
    @IBOutlet var emailTextField: XMTextField!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBActions
    
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        var errMsg : String = ""
        
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            print("\(emailTextField.text ?? "") \(passwordTextField.text ?? "")" )
            errMsg = "Empty email or password"
        } else if !isValidEmail(testStr: emailTextField.text!) {
            errMsg = "Invalid Email"
        }
        
        if !errMsg.isEmpty {
            print("\(errMsg)")
            setupAlert(title: "Error !", message: errMsg)
        } else {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if(user != nil) {
                    self.performSegue(withIdentifier: "login", sender: self)
                } else {
                    self.setupAlert(title: "Error !", message: "Failed to Login. Please try again later.")
                }
            }
        }
    }
    
    
    @IBAction func loginWithFaceBookBtnClicked(_ sender: Any) {
        
        let fbLoginManager = FBSDKLoginManager ()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, loginError) in
            
            if (loginError != nil) {
                
                self.setupAlert(title: "Error !", message: "Process Error")
                
            } else if (result?.isCancelled)! {
                self.setupAlert(title: "Alert !", message: "Facebook Login Cancelled")
            } else {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential) { (user, error) in
                    
                    if error != nil {
                        
                        self.setupAlert(title: "Error !", message: "Failed to Login. Please try again later.")
                        return
                        
                    } else {
                        // User is signed in
                        // ...
                        self.performSegue(withIdentifier: "login", sender: self)
                    }
                }
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MERK: - Methods
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func setupAlert(title: String , message :String)  {
        
        let alert : UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction : UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (data) in
            
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        scrlContainer.setContentOffset(CGPoint(x:0,y:textField.frame.origin.y-20), animated: true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(emailTextField) {
            passwordTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        scrlContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
