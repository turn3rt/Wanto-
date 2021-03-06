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

    var ref: DatabaseReference!
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logoView: UIStackView!
    
    
    @IBAction func tapOffKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
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
            self.view.frame.origin.y -= 180 //keyboardSize.height
            logoView.isHidden = true
        }
        // }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 180 //keyboardSize.height
            logoView.isHidden = false
        }
        // }
    }
    
    @IBAction func createAccount(_ sender: UIButtonX) {
        
        let username = self.username.text
        let name = self.name.text
        let email = self.email.text
        let password = self.password.text
        
        
        
//        let takenUserRef = Constants.refs.takenUsernames
//        takenUserRef.child(username!).observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.exists() {
//                print("oh shit username taken")
//            } else {
//                print("we good fam")
//            }
//        }
//        userRef.queryOrdered(byChild: "Email").queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.value is NSNull {
//                print("we good fam no other user made a unique username")
//            } else {
//                print(snapshot.value)
//                print("oh shit user didn't make unique username")
//            }
//        }
        
        //        let userName = the userName or email the user entered
//        let usersRef = Firebase(url:"https://test.firebaseio.com/users")
//        usersRef.queryOrderedByChild("email").queryEqualToValue("\(userName!)")
//            .observeSingleEventOfType(.Value, withBlock: { snapshot in
//
//                if ( snapshot.value is NSNull ) {
//                    print("not found)") //didnt find it, ok to proceed
//
//                } else {
//                    print(snapshot.value) //found it, stop!
//                }
//        }
        
        
        
        if (name != "") && (email != "") && (password != "") && (username != "") {
            Auth.auth().createUser(withEmail: email!, password: password!, completion: {(user: User? , error) in
                //unsuccessful creation attempt, spits out error
                if error != nil{
                    self.signupErrorAlert(title: "Error!", message: String(describing: error!))
                    print(error!)
                }
                //successful account creation
                let userID: String = user!.uid //gets UNIQUE user id

                self.ref.child("Users").child(userID).setValue(["Username": username!,
                                                                "Name": name!,
                                                                "Email":email!,
                                                                "uid": userID ])
                //DOUBLY CHECK CODE FOR PRODUCTION
               // self.ref.child("takenUsernames").setValue(username!) //sets username to taken usernames in firebase, to check if they exist on login


                Auth.auth().currentUser?.sendEmailVerification(completion: {(error) in
                    //self.signupErrorAlert(title: "Success!", message: "Verification email sent to: \(email!)")
                    let alert = UIAlertController(title: "Success!", message: "Email verification sent to \(email!). Confirm by clicking the link provided in the email body.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: { (action) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    print("email sent to : \(email!), creating uid of: \(userID)")
                })
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
