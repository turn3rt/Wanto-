//
//  ActiveCell.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/1/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit
import Firebase


class ActiveCell: UITableViewCell {
    //MARK: Database ref
    var ref: DatabaseReference!
    var refHandle: UInt!
    let userID: String = (Auth.auth().currentUser?.uid)!
    

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var countdownTimer: UILabel!
    

    
    var activity = Activity(id: String(),
                            name: String(),
                            isActive: Bool(),
                            privacySetting: String(),
                            people: [Person](),
                            locationString: String(),
                            locationCoords: CLLocationCoordinate2D(),
                            locLat: Double(),
                            locLong: Double())
    
//    @IBAction func cancelClick(_ sender: UIButtonX) {
//        ref = Database.database().reference().child("Users/\(userID)/Activities")
//        self.activity.isActive = false
//        self.ref.child(self.activity.id).setValue([ "id": self.activity.id,
//                                                    "name": self.activity.name,
//                                                    "isActive": self.activity.isActive,
//                                                    "locString": self.activity.locationString,
//                                                    "locLat": self.activity.locLat,
//                                                    "locLong": self.activity.locLong,
//                                                    "privacySetting": self.activity.privacySetting])
//    }
    
   
}
