//
//  activitySettingsController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/6/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit

protocol personDeleteDelegate {
    func deletePerson(atIndexPath: Int)
}

protocol reorderDelegate {
    func reorder(activity: Activity)
}



class activitySettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var deleteDelegate: personDeleteDelegate? = nil
    var reorderDelegate: reorderDelegate? = nil
    
    
    var activity = Activity(id: String(),
                            name: String(),
                            isActive: false,
                            privacySetting: String(),
                            people: [Person](),
                            locationString: String(),
                            locationCoords: CLLocationCoordinate2D(),
                            locLat: Double(),
                            locLong: Double())
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var editDoneButton: UIBarButtonItem!
    
    @IBAction func editDoneButtonClick(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        switch tableView.isEditing {
        case true:
            editDoneButton.title = "Done"
        case false:
            editDoneButton.title = "Edit"
            reorderDelegate?.reorder(activity: self.activity)
        }
    }
    
    @IBAction func privacyButtonClick(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "People who can see your activity", preferredStyle: .actionSheet)
        
        // 2
        let everyone = UIAlertAction(title: "Everyone", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Tapped Everyone")
            self.activity.privacySetting = "Everyone"
            self.privacyButton.setTitle(self.activity.privacySetting, for: .normal)
        })
        let friends = UIAlertAction(title: "Friends", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("tapped friends")
            self.activity.privacySetting = "Friends"
            self.privacyButton.setTitle(self.activity.privacySetting, for: .normal)


        })
        let onlyGroup = UIAlertAction(title: "Only Group", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("tapped only group")
            self.activity.privacySetting = "Only Group"
            self.privacyButton.setTitle(self.activity.privacySetting, for: .normal)

            
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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.privacyButton.setTitle(activity.privacySetting, for: .normal)
        self.tableView.isEditing = true
        
        print("activity: \(activity)")
        
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedName = self.activity.people[sourceIndexPath.row]
        activity.people.remove(at: sourceIndexPath.row)
        activity.people.insert(movedName, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(activity.people)")
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell") as! PeopleCell
        let first = activity.people[indexPath.row].firstName
        let last = activity.people[indexPath.row].lastName
        cell.nameLabel.text = first + " " + last
        return cell
        
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //activity.people.remove(at: indexPath.row)
            deleteDelegate?.deletePerson(atIndexPath: indexPath.row)
            self.tableView.reloadData()
            
        }
    }
}
