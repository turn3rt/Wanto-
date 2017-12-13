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
                self.signupErrorAlert(title: "Error!", message: String(describing: error))
            }
        })
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
