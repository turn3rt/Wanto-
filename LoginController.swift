//
//  LoginController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/12/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {
    

    

    
  
    
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    var kbHeight: CGFloat!
    
    
    @IBAction func tapOffKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 216 //keyboardSize.height
            }
       // }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 216 //keyboardSize.height
            }
       // }
    }
    @IBAction func loginClick(_ sender: UIButtonX) {
        let email = emailField.text
        let pass = passwordField.text
        
        Auth.auth().signIn(withEmail: email!, password: pass!, completion: {(user, error) in
            if error != nil {
                self.signupErrorAlert(title: "Error!", message: String(describing: error!))
            } else {
                if Auth.auth().currentUser?.isEmailVerified == true {
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
               let alert = UIAlertController(title: "Email Verification Needed", message: "Please verify \(email!) by clicking the verification link provided in the email body.", preferredStyle: .alert)
                let resendAction = UIAlertAction(title: "Resend", style: .destructive, handler: { (action) -> Void in
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    self.signupErrorAlert(title: "Success!", message: "Verification email sent to: \(email!)")
                })
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                })
                
                alert.addAction(resendAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                //                let alert = UIAlertController(title: "Email verification needed", message: "Please verify \(email!) by clicking on the verification link provided in the email body", preferredStyle: UIAlertControllerStyle.alert)
//                let resend = UIAlertAction(title: "Resend Email", style: .default, handler: {()})
//                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)

            }
    
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
            let homeVC = segue.destination as! UITabBarController
            //@TODO: configure userdata here
        }
        
    }
    
    
    @IBAction func forgotPassClick(_ sender: UIButtonX) {
        
    }
    
    
    func signupErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
}
