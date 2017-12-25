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
    var isActive: Bool
    var privacySetting: String
    var people: [Person]
    var locationString: String
    var locationCoords: CLLocationCoordinate2D
    var locLat: Double
    var locLong: Double
    var countdownValue: Double
    var timerIsRunning: Bool
    
    init(id: String, name: String, isActive: Bool, privacySetting: String, people: [Person], locationString: String, locationCoords: CLLocationCoordinate2D, locLat: Double, locLong: Double, countdownValue: Double, timerIsRunning: Bool) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.privacySetting = privacySetting
        self.people = people
        self.locationString = locationString
        self.locationCoords = locationCoords
        self.locLat = locLat
        self.locLong = locLong
        self.countdownValue = countdownValue
        self.timerIsRunning = timerIsRunning
    }
//    var location: String?
//    var people: [String]?
    
    
}
