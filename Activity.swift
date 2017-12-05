//
//  Activity.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/3/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import Foundation
import MapKit

class Activity{
    var name: String
    var locationString: String
    
    //var locationCoords: CLLocationCoordinate2D
    var people: [String]
    
    init(name: String, people: [String], locationString: String) {
        self.name = name
        self.people = people
        self.locationString = locationString
    }
//    var location: String?
//    var people: [String]?
    
    
}
