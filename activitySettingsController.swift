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
    
    @IBAction func privacyButtonClick(_ sender: UIButton) {
        
    }
    @IBAction func trashClick(_ sender: UIBarButtonItem) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
