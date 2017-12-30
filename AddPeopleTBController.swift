//
//  AddPeopleTBController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import Firebase

class AddPeopleTBController: UITableViewController {

    //MARK DATABASE REF:
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    let userID: String = (Auth.auth().currentUser?.uid)!
    
    //@IBOutlet weak var SocialGroupSegmentControl: UISegmentedControl!
    
    var addPersonArray = [Person]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getEveryUser()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return addPersonArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let personCell = tableView.dequeueReusableCell(withIdentifier: "AddPeopleCell", for: indexPath) as! AddPeopleCell
        
        personCell.nameLabel.text = addPersonArray[indexPath.row].firstName
        personCell.userNameLabel.text = addPersonArray[indexPath.row].lastName
        
        return personCell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: "SocialGroupHeader")
    }
    
    func getEveryUser(){
        Constants.refs.databaseUsers.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                let dbPerson = Person(firstName: String(),
                                      lastName: String(),
                                      profileImage: UIImage())
                
                let dbFullName = dict["Name"] as? String ?? "Name not found"
                let dbUserName = dict["Username"] as? String ?? "Username not found"
                
                dbPerson.firstName = dbFullName //first name is full name
                dbPerson.lastName = dbUserName //last name is username b/c i'm a lazy fuck and don't want to change person model
                
                self.addPersonArray.append(dbPerson)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    func getFriends(){
        //@TODO:
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
