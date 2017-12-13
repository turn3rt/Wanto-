//
//  CreateAccountController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/12/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import Firebase




class CreateAccountController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    
    @IBAction func tapOffKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        email.delegate = self
        password.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()
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
    
    @IBAction func createAccount(_ sender: UIButtonX) {
        let name = self.name.text
        let email = self.email.text
        let password = self.password.text
        
        if (name != "") && (email != "") && (password != "") {
            Auth.auth().createUser(withEmail: email!, password: password!, completion: {(user: User? , error) in
                if error != nil{
                    self.signupErrorAlert(title: "Error!", message: String(describing: error))
                    print(error!)
                }
                Auth.auth().currentUser?.sendEmailVerification(completion: {(error) in
                    print("email sent to : \(email!)")
                })
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            signupErrorAlert(title: "Authentication Error", message: "Please complete all fields before continuing")
        }
        
    }
   
    func signupErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func cancelTap(_ sender: UIButtonX) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
 

}
