//
//  ActiveViewController.swift
//  Wanto
//
//  Created by Turner Thornberry on 11/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit
import ContactsUI
import Contacts

class ActiveViewController: UIViewController, CNContactPickerDelegate {
    
    private let personIdentifier = "Person"
    private let noPersonIdentifier = "NoPerson"
    
    
    
    
    @IBOutlet weak var navigationTitle: UIButton!
    @IBOutlet weak var timeDateSwitch: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var privacyButton: UIButton!
    
    var people = ["Sally", "Alvaro", "Quinn", "Natalie", "Fernanda", "Cole", "Nick", "Ian", "Reid"]
    
    var numeroADiscar: String = ""
    var userImage: UIImage? = nil
    var nameToSave = ""
    
    
    @IBAction func titleButtonTap(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add activity name:", message: "", preferredStyle: .alert)
        
        //add text field
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter name..."
        }
        
        
        //change title to entered text
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0]
            self.navigationTitle.setTitle(textField.text, for: UIControlState.normal)
        })
            
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
       
        //add actions to alert sheet
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)

        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func switchValue(_ sender: UISegmentedControl) {
        if timeDateSwitch.selectedSegmentIndex == 0 {
            datePicker.datePickerMode = .countDownTimer
        } else if timeDateSwitch.selectedSegmentIndex == 1 {
            datePicker.datePickerMode = .dateAndTime
        }
    }
    
    
    @IBAction func addPeopleClick(_ sender: UIButtonX){
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
    
    func openContacts() {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        //@TODO: need to hide status bar
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    //MARK: Delegate Functions for CNContactPickerVC
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    // do something with contact
        
        // this is for the full name
        let fullname = "\(contact.givenName) \(contact.familyName)"
        print("The selected name is: \(fullname)")

        
        //this one is for getting first number with dashshes in it
        let phoneNumber =  ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value") as AnyObject).value(forKey: "stringValue")) ?? "No Number Listed" // returns string value of phone number without all the bullshit
        print("The selected phone num is: \(phoneNumber)")

       //this is for phone number without dashes
       //print("the selected phone number is: \((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)")
    }

    
    
    
//
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//        let selectedContactNames = contacts
//        print(" ASSJ AS;DLKJSADF;KJLSDF;JSADF;JD FA;LKAJSDF;LJ PAHDOISJF!!!!!1: \(String(describing: selectedContacts))")
////        print("\(contacts)")
//////                print("The selected name is: \(contact.familyName)")
//    }
    
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//
//        // I only want single selection
//        if contacts.count != 1 {
//
//            return
//
//        } else {
//
//            //Dismiss the picker VC
//            picker.dismiss(animated: true, completion: nil)
//
//            let contact: CNContact = contacts[0]
//
//            //See if the contact has multiple phone numbers
//            if contact.phoneNumbers.count > 1 {
//
//                //If so we need the user to select which phone number we want them to use
//                let multiplePhoneNumbersAlert = UIAlertController(title: "Which one?", message: "This contact has multiple phone numbers, which one did you want use?", preferredStyle: UIAlertControllerStyle.alert)
//
//                //Loop through all the phone numbers that we got back
//                for number in contact.phoneNumbers {
//
//                    //Each object in the phone numbers array has a value property that is a CNPhoneNumber object, Make sure we can get that
//                    let actualNumber = number.value as CNPhoneNumber
//
//                    //Get the label for the phone number
//                    var phoneNumberLabel = number.label
//
//                    //Strip off all the extra crap that comes through in that label
//                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "")
//                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "")
//                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "")
//                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "")
//                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "")
//
//                    //Create a title for the action for the UIAlertVC that we display to the user to pick phone numbers
//                    let actionTitle = phoneNumberLabel! + " - " + actualNumber.stringValue
//
//                    //Create the alert action
//                    let numberAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: { (theAction) -> Void in
//
//                        //See if we can get A frist name
//                        if contact.givenName == "" {
//
//                            //If Not check for a last name
//                            if contact.familyName == "" {
//                                //If no last name set name to Unknown Name
//                                self.nameToSave = "Unknown Name"
//                            }else{
//                                self.nameToSave = contact.familyName
//                            }
//
//                        } else {
//
//                            self.nameToSave = contact.givenName
//
//                        }
//                        
//                        // See if we can get image data
//                        if let imageData = contact.imageData {
//                            //If so create the image
//                            self.userImage = UIImage(data: imageData)!
//                        }
//
//                        //Do what you need to do with your new contact information here!
//                        //Get the string value of the phone number like this:
//                        self.numeroADiscar = actualNumber.stringValue
//
//                    })
//
//                    //Add the action to the AlertController
//                    multiplePhoneNumbersAlert.addAction(numberAction)
//
//                }
//
//                //Add a cancel action
//                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (theAction) -> Void in
//                    //Cancel action completion
//                })
//                
//                //Add the cancel action
//                multiplePhoneNumbersAlert.addAction(cancelAction)
//
//                //Present the ALert controller
//                self.present(multiplePhoneNumbersAlert, animated: true, completion: nil)
//
//            } else {
//
//                //Make sure we have at least one phone number
//                if contact.phoneNumbers.count > 0 {
//
//                    //If so get the CNPhoneNumber object from the first item in the array of phone numbers
//                    let actualNumber = (contact.phoneNumbers.first?.value)! as CNPhoneNumber
//
//                    //Get the label of the phone number
//                    var phoneNumberLabel = contact.phoneNumbers.first!.label
//
//                    //Strip out the stuff you don't need
//                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "")
//                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "")
//                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "")
//                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "")
//                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "")
//
//                    //Create an empty string for the contacts name
//                    self.nameToSave = ""
//                    //See if we can get A frist name
//                    if contact.givenName == "" {
//                        //If Not check for a last name
//                        if contact.familyName == "" {
//                            //If no last name set name to Unknown Name
//                            self.nameToSave = "Unknown Name"
//                        }else{
//                            self.nameToSave = contact.familyName
//                        }
//                    } else {
//                        nameToSave = contact.givenName
//                    }
//
//                    // See if we can get image data
//                    if let imageData = contact.imageData {
//                        //If so create the image
//                        self.userImage = UIImage(data: imageData)
//                    }
//                    
//                    //Do what you need to do with your new contact information here!
//                    //Get the string value of the phone number like this:
//                    self.numeroADiscar = actualNumber.stringValue
//
//                } else {
//
//                    //If there are no phone numbers associated with the contact I call a custom funciton I wrote that lets me display an alert Controller to the user
//                    let alert = UIAlertController(title: "Missing info", message: "You have no phone numbers associated with this contact", preferredStyle: UIAlertControllerStyle.alert)
//                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alert.addAction(cancelAction)
//                    present(alert, animated: true, completion: nil)
//
//                }
//            }
//        }
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
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
    
    @IBAction func privacyButtonClick(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "People who can see your activity", preferredStyle: .actionSheet)
        
        // 2
        let everyone = UIAlertAction(title: "Everyone", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Tapped Everyone")
            self.privacyButton.titleLabel?.text = "Everyone"
            
        })
        let friends = UIAlertAction(title: "Friends", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("tapped friends")
            self.privacyButton.titleLabel?.text = "Friends"
            
        })
        let onlyGroup = UIAlertAction(title: "Only Group", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("tapped only group")
            self.privacyButton.titleLabel?.text = "Only Group"
            
            
        })
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("tapped cancel")
            
        })
        
        
        // 4
        optionMenu.addAction(everyone)
        optionMenu.addAction(friends)
        optionMenu.addAction(onlyGroup)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
}






extension ActiveViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of People: \(people.count)")
        if people.count == 0{
            return 1
        } else {
            return people.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if people.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noPersonIdentifier, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: personIdentifier, for: indexPath) as! PersonCell
            cell.name.text = people[indexPath.row]
            return cell
        }
    }
}
