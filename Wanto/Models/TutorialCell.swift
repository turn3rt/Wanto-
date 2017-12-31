//
//  TutorialCell.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/13/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class TutorialCell: UITableViewCell {
    
    @IBOutlet weak var tutHeaderLabel: UILabel!
    @IBOutlet weak var notFoundButton: UIButton!
    
    var newActivity: Activity!
    
    
    @IBAction func addWithPhoneNumClick(_ sender: UIButton) {
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
        let contactPicker = CNContactPickerViewController()
        let numKeys = [CNContactPhoneNumbersKey]
        contactPicker.displayedPropertyKeys = numKeys
        contactPicker.delegate = InactiveViewController()
        //@TODO: need to hide status bar
        UIApplication.topViewController()!.present(contactPicker, animated: true, completion: nil)
    }
    
    
    
    //MARK: Delegate Functions for CNContactPickerVC
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let newPerson = Person(firstName: contact.givenName,
                               lastName: contact.familyName,
                               profileImage: #imageLiteral(resourceName: "capitalizing_on_the_economic_potential_of_foreign_entrepreneurs_feature.png") )
        
        if newActivity.people.contains(where: { $0.firstName == newPerson.firstName && $0.lastName == newPerson.lastName}) {
            print("Person Already added error")
            let alertController = UIAlertController(title: "Error: Person already added!", message: "", preferredStyle: .alert)
            //            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: {
            //                alert -> Void in
            //            })
            
            //alertController.addAction(confirmAction)
            picker.present(alertController, animated: true, completion: nil)
        } else {
            if contact.imageDataAvailable == true {
                newPerson.profileImage = UIImage(data: contact.imageData!)!
            }
            
            // this is for the full name
            let fullname = "\(contact.givenName) \(contact.familyName)"
            print("The selected name is: \(fullname)")
            //            let phoneNum = contact.phoneNumbers.first?.value.stringValue
            //            print("The selected phone num is: \(phoneNum!)")
            
            //appends data to new activity model for prep to send back to home vc
            newActivity.people.append(newPerson)
            print("the people in the new activity array are: \(newActivity.people)")
            
            InactiveViewController().peopleCollection.reloadData()
            
        }
        
    }
}

