//
//  SettingsController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/2/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import Firebase

class SettingsController: UITableViewController {
    let userID: String = (Auth.auth().currentUser?.uid)!
    let storageRef = Storage.storage().reference()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImage: UIImageViewX!
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getUserSettings()
        getProfilePicture()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func getUserSettings() {
        Constants.refs.databaseUsers.child(userID).observe(DataEventType.value) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                let dbName = dict["Name"] as? String ?? "Name not Found"
                let dbUsername = dict["Username"] as? String ?? "Username not found"
                self.nameLabel.text = dbName
                self.username.text = dbUsername
                
            }
        }
    }
    
    func getProfilePicture(){
        Constants.refs.databaseUsers.child(userID).observe(DataEventType.value, with: { (snapshot) in
            // check if user has photo
            if snapshot.hasChild("profilePic"){
                // set image locatin
                let filePath = "Users/\(self.userID)/\("profilePic")"
                // Assuming a < 10MB file, though mutable
                self.storageRef.child(filePath).getData(maxSize: 10*1024*1024, completion: { (data, error) in
                    
                    let userPhoto = UIImage(data: data!)
                    self.profileImage.image = userPhoto
                })
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile"{
            
            //check why this isn't working wtf
            let editProfileVC = segue.destination as! EditProfileViewController
            if self.profileImage != nil {
                editProfileVC.profileImage = self.profileImage
                
            }
        }
    }

//    func getEveryUser(){
//        Constants.refs.databaseUsers.observe(.childAdded) { (snapshot) in
//            if let dict = snapshot.value as? [String: AnyObject]{
//                let dbPerson = Person(firstName: String(),
//                                      lastName: String(),
//                                      profileImage: UIImage())
//
//                let dbFullName = dict["Name"] as? String ?? "Name not found"
//                let dbUserName = dict["Username"] as? String ?? "Username not found"
//
//                dbPerson.firstName = dbFullName //first name is full name
//                dbPerson.lastName = dbUserName //last name is username b/c i'm a lazy fuck and don't want to change person model
//
//                self.addPersonArray.append(dbPerson)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//
//        }
//    }
}
