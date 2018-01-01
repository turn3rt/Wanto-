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
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var username: UILabel!
    
   let userID: String = (Auth.auth().currentUser?.uid)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getUserSettings()
        
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
