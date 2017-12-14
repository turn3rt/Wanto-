//
//  Activity.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/3/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import Foundation
import MapKit

class Activity {
    var id: String
    var name: String
    var privacySetting: String
    var people: [Person]
    var locationString: String
    var locationCoords: CLLocationCoordinate2D
    
    init(id: String, name: String, privacySetting: String, people: [Person], locationString: String, locationCoords: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.privacySetting = privacySetting
        self.people = people
        self.locationString = locationString
        self.locationCoords = locationCoords
    }
//    var location: String?
//    var people: [String]?
    
    
}
