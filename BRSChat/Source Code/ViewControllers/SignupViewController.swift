//
//  SignupViewController.swift
//  BRSChat
//
//  Created by Bindu on 23/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var scrolContainer: UIScrollView!
    @IBOutlet var confirmPasswordTextField: XMTextField!
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
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnClikced(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func signupBtnClicked(_ sender: Any) {
        
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
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if (user != nil) {
                    self.performSegue(withIdentifier: "signup", sender: self)
                } else {
                    self.setupAlert(title: "Error !", message: "Failed to Login. Please try again later.")
                }
            }
        }
    }
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrolContainer.setContentOffset(CGPoint(x:0,y:textField.frame.origin.y-20), animated: true)
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
        scrolContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
