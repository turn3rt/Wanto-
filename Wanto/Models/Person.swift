//
//  Person.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/6/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import Foundation
import UIKit

class Person{
    var firstName: String
    var lastName: String
    var profileImage: UIImage
   // var phoneNum: [String]
 
    
    init(firstName: String,  lastName: String, profileImage: UIImage) {
        self.firstName = firstName
        self.lastName = lastName
        self.profileImage = profileImage
    }

}
