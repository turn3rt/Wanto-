//
//  InactiveViewController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/17/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit
import ContactsUI
import Contacts
import CoreLocation
import Firebase


protocol cancelDelegate{
    func cancel(data: Activity, selectedCellIndex: Int)
}

class ActiveViewController: UIViewController {
    //MARK: Database ref
    var ref: DatabaseReference!
    var activitiesRef: DatabaseReference!
    var refHandle: UInt!
    let userID: String = (Auth.auth().currentUser?.uid)!
    
    
    @IBOutlet weak var standardTimeLabel: UILabel!
   
    
    var activity = Activity(id: String(),
                            name: String(),
                            isActive: Bool(),
                            privacySetting: String(),
                            people: [Person](),
                            locationString: String(),
                            locationCoords: CLLocationCoordinate2D(),
                            locLat: Double(),
                            locLong: Double())
    
    var cancelDelegate: cancelDelegate? = nil
    var selectedCellIndex = Int()
    
    @IBAction func cancelClick(_ sender: UIButtonX) {
        let alertController = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
            alert -> Void in
            if self.cancelDelegate != nil{
                self.cancelDelegate?.cancel(data: self.activity, selectedCellIndex: self.selectedCellIndex)
                self.ref = Database.database().reference().child("Users/\(self.userID)/Activities")
                self.activity.isActive = false
                self.ref.child(self.activity.id).setValue([ "id": self.activity.id,
                                                            "name": self.activity.name,
                                                            "isActive": self.activity.isActive,
                                                            "locString": self.activity.locationString,
                                                            "locLat": self.activity.locLat,
                                                            "locLong": self.activity.locLong,
                                                            "privacySetting": self.activity.privacySetting])
            }
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
    
        //add actions to alert sheet
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func getTime(){
        let timeRef = Database.database().reference().child("Users").child(userID).child("Activities").child(activity.id).observe(.value, with: {(snapshot) in
            let dict = snapshot.value as? [String: Any] ?? [:]
            let targetTime = dict["targetTime"] as? Double ?? 0000
    
            print(self.convertTimestamp(serverTimestamp: targetTime))
            self.standardTimeLabel.text = self.convertTimestamp(serverTimestamp: targetTime)
        })
        print("\(timeRef)")
//        ref.child("Users").child(userID).child("Activities").child("targetTime").observe(.childAdded, with: {(snapshot) in
//            if let dict = snapshot.value as? [String: AnyObject] {
//                let dbTime  = dict["targetTime"] as? String ?? "zero"
//                self.standardTimeLabel.text = String(describing: dbTime)
//            }
//            DispatchQueue.main.async {
//
//            }
//        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getTime()
    }
    
    
    
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: date as Date)
    }
}



