//
//  AddPeopleTBController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import Firebase
import ContactsUI


protocol addPeopleDelegate{
    func addPerson(data: Person)
}

class AddPeopleTBController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate {

    //MARK DATABASE REF:
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    let userID: String = (Auth.auth().currentUser?.uid)!
    
    //@IBOutlet weak var SocialGroupSegmentControl: UISegmentedControl!
    
    var addPersonArray = [Person]()
    
    var newActivity = Activity(id: String(),
                               name: "Add name...",
                               isActive: false,
                               privacySetting: "Friends",
                               people: [Person](),
                               locationString: "Add location...",
                               locationCoords: CLLocationCoordinate2D(),
                               locLat: Double(),
                               locLong: Double(),
                               countdownValue: Double(),
                               timerIsRunning: false)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var socialGroupControl: UISegmentedControl!
    
    
    //delegate vars
    var addPersonDelegate: addPeopleDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //getEveryUser()

    }
    @IBAction func indexDidChange(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       //if SocialGroupControl.selectedSegmentIndex == 0 ? 0 : addPersonArray.count
        
        
        if socialGroupControl.selectedSegmentIndex == 0 {
            return 1
        } else {
            return addPersonArray.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let personCell = tableView.dequeueReusableCell(withIdentifier: "AddPeopleCell", for: indexPath) as! AddPeopleCell
        let noPerson = tableView.dequeueReusableCell(withIdentifier: "NotFound", for: indexPath) as! TutorialCell
        
        if socialGroupControl.selectedSegmentIndex == 0 {
            return noPerson
        } else {
            personCell.nameLabel.text = addPersonArray[indexPath.row].firstName
            personCell.userNameLabel.text = addPersonArray[indexPath.row].lastName
            return personCell
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if socialGroupControl.selectedSegmentIndex == 0 {
            let entitiyType = CNEntityType.contacts
            let authStatus = CNContactStore.authorizationStatus(for: entitiyType)
            
            if authStatus == .notDetermined {
                let contactsStore = CNContactStore.init()
                contactsStore.requestAccess(for: entitiyType, completionHandler: { (success, nil) in
                    if success {
                        self.openContacts()
                    } else {
                        //@TODO: add action sheet to take user directly to settings
                        print("not authorized")
                    }
                })
            }
            else if authStatus == .authorized {
                openContacts()
            }
            
        }
    }
    
    func openContacts() {
        let contactPicker = CNContactPickerViewController()
        let numKeys = [CNContactPhoneNumbersKey]
        contactPicker.displayedPropertyKeys = numKeys
        contactPicker.delegate = self
        //@TODO: need to hide status bar
        self.present(contactPicker, animated: true, completion: nil)
    }
    
//    var selectedContact = CNContact()
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//        selectedContact = contact
//    }
    
    
    
    var theContactName: String?
    var thePhoneNumber: String?
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        let newPerson = Person(firstName: contactProperty.contact.givenName,
                               lastName: contactProperty.contact.familyName,
                               profileImage: #imageLiteral(resourceName: "capitalizing_on_the_economic_potential_of_foreign_entrepreneurs_feature.png") )
        
        //checks if person is already in activity array to prevent duplicates being added b/c users are dumbshits
        if addPersonArray.contains(where: { $0.firstName == newPerson.firstName && $0.lastName == newPerson.lastName}) {
            print("Person Already added error")
            let alertController = UIAlertController(title: "Error: Person already added!", message: "", preferredStyle: .alert)
            //            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: {
            //                alert -> Void in
            //            })
            
            //alertController.addAction(confirmAction)
            picker.present(alertController, animated: true, completion: nil)
        } else {
            if contactProperty.contact.imageDataAvailable == true {
                newPerson.profileImage = UIImage(data: contactProperty.contact.imageData!)!
            }
            
        }
        
        theContactName = contactProperty.contact.givenName + " " + contactProperty.contact.familyName
        thePhoneNumber = (contactProperty.value as! CNPhoneNumber).stringValue
        
        addPersonArray.append(newPerson)
        print("added " + theContactName! + " with phone num: " + thePhoneNumber!)
        addPersonDelegate?.addPerson(data: newPerson)

        self.navigationController?.popViewController(animated: true)
    }
    
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
//        let nameOfContact = selectedContact.givenName + selectedContact.familyName
//        let phoneNumber =
//        print("\(nameOfContact)" + "phone num is:  ")
//    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return tableView.dequeueReusableCell(withIdentifier: "SocialGroupHeader")
//    }
    
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
