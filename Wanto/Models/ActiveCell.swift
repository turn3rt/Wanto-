//
//  ActiveCell.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/1/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit

class ActiveCell: UITableViewCell {

    
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
    
    
    
   
}
