//
//  LoginController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/12/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {

    

    
    @IBAction func tapOffKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var kbHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameField.delegate = self
        passwordField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
