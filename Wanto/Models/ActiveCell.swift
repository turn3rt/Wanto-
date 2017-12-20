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

protocol returnToInactiveDelegate {
    func activeToInactive(data: Activity)
}


class ActiveCell: UITableViewCell {
    //MARK: Database ref
    var ref: DatabaseReference!
    var refHandle: UInt!
    let userID: String = (Auth.auth().currentUser?.uid)!
    

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var countdownTimer: UILabel!
    
    var timer = Timer()
    var startTime = Double()
    var timerIsRunning = false
    var returnToInactiveDelegate: returnToInactiveDelegate? = nil
    
    var activity = Activity(id: String(),
                            name: String(),
                            isActive: Bool(),
                            privacySetting: String(),
                            people: [Person](),
                            locationString: String(),
                            locationCoords: CLLocationCoordinate2D(),
                            locLat: Double(),
                            locLong: Double(),
                            countdownValue: Double())
    

    
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
//
//    }
    
    func handleCountdown(){
        timerIsRunning = true
        startTime = activity.countdownValue
        runTimer()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer(){
        let hours = Int(startTime) / 3600
        let minutes = Int(startTime) / 60 % 60
//        let seconds = Int(startTime) % 60
        
        if startTime > 0 {
            startTime -= 1
            switch startTime {
            case 0..<60: //display seconds
                countdownTimer.text = String(Int(startTime)) + "s"
            case 60..<3600: //display minutes
                countdownTimer.text = String(Int(minutes)) + "m"
            case 3600..<86400: // display hours and minutes
                countdownTimer.text = String(Int(hours)) + "h \(minutes)m"
            default:
                timer.invalidate()
            }
        }
        
        
        
        if startTime == 0 {
            activity.isActive = false
            timer.invalidate()
            returnToInactiveDelegate?.activeToInactive(data: activity)
        }
    }
    
//    func timeString(time: Double) -> (hours: String, minutes: String, seconds: String){
//        let hours = Int(time) / 3600
//        let minutes = Int(time) / 60 % 60
//        let seconds = Int(time) % 60
//
//        return (hours: String(format:"%02i", hours), minutes: String(format:"%02i", minutes), seconds: String(format:"%02i", seconds))
//    }
   
}
