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
    var username: String
    //var profileImage: UIImage
    var imageURL: String
    var phoneNum: String
 
    
    init(firstName: String,  lastName: String, username: String, imageURL: String, phoneNum: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        //self.profileImage = profileImage
        self.imageURL = imageURL
        self.phoneNum = phoneNum
    }

}
