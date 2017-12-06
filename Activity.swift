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
    var privacySetting: String
    var people: [Person]
    var locationString: String
   // var locPlacemark: MKPlacemark
    
    init(name: String, privacySetting: String, people: [Person], locationString: String){ //}, locPlacemark: MKPlacemark) {
        self.name = name
        self.privacySetting = privacySetting
        self.people = people
        self.locationString = locationString
       // self.locPlacemark = locPlacemark
    }
//    var location: String?
//    var people: [String]?
    
    
}
