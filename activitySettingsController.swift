//
//  activitySettingsController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/6/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit

class activitySettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    var activity = Activity(name: String(), privacySetting: String(), people: [Person](), locationString: String(), locationCoords: CLLocationCoordinate2D())
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var privacyButton: UIButton!
    
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
    @IBAction func trashClick(_ sender: UIBarButtonItem) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.privacyButton.setTitle(activity.privacySetting, for: .normal)
        
        print("activity: \(activity)")
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
}
