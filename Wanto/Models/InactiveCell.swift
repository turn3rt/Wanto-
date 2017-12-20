//
//  InactiveCell.swift
//  Wanto
//
//  Created by Turner Thornberry on 11/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit
import Firebase



class InactiveCell: UITableViewCell, MKMapViewDelegate {
    //MARK: Database ref
    var ref: DatabaseReference!
    var refHandle: UInt!
    let userID: String = (Auth.auth().currentUser?.uid)!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var privacySetting: UIButtonX!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var activity = Activity(id: String(),
                            name: String(),
                            isActive: false,
                            privacySetting: String(),
                            people: [Person](),
                            locationString: String(),
                            locationCoords: CLLocationCoordinate2D(),
                            locLat: Double(),
                            locLong: Double(),
                            countdownValue: Double())
    
    func showLocInMiniMap(coordinates: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = activity.locationCoords
        //annotation.title = ""
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.025, 0.05)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func privacyButtonClick(_ sender: UIButtonX) {
        ref = Database.database().reference().child("Users/\(userID)/Activities")


        
        let optionMenu = UIAlertController(title: nil, message: "People who can see your activity", preferredStyle: .actionSheet)
        
        // 2
        let everyone = UIAlertAction(title: "Everyone", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Tapped Everyone")
            self.activity.privacySetting = "Everyone"
            self.privacySetting.setTitle(self.activity.privacySetting, for: .normal)
            self.ref.child(self.activity.id).setValue([ "id": self.activity.id,
                                                        "name": self.activity.name,
                                                        "isActive": self.activity.isActive,
                                                        "locString": self.activity.locationString,
                                                        "locLat": self.activity.locLat,
                                                        "locLong": self.activity.locLong,
                                                        "privacySetting": self.activity.privacySetting])
        })
        let friends = UIAlertAction(title: "Friends", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("tapped friends")
            self.activity.privacySetting = "Friends"
            self.privacySetting.setTitle(self.activity.privacySetting, for: .normal)
            self.ref.child(self.activity.id).setValue([ "id": self.activity.id,
                                                        "name": self.activity.name,
                                                        "isActive": self.activity.isActive,
                                                        "locString": self.activity.locationString,
                                                        "locLat": self.activity.locLat,
                                                        "locLong": self.activity.locLong,
                                                        "privacySetting": self.activity.privacySetting])

            
        })
        let onlyGroup = UIAlertAction(title: "Only Group", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("tapped only group")
            self.activity.privacySetting = "Only Group"
            self.privacySetting.setTitle(self.activity.privacySetting, for: .normal)
            self.ref.child(self.activity.id).setValue([ "id": self.activity.id,
                                                        "name": self.activity.name,
                                                        "isActive": self.activity.isActive,
                                                        "locString": self.activity.locationString,
                                                        "locLat": self.activity.locLat,
                                                        "locLong": self.activity.locLong,
                                                        "privacySetting": self.activity.privacySetting])

            
        })
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("tapped cancel")
            
        })
        
        
        // 4
        optionMenu.addAction(everyone)
        optionMenu.addAction(friends)
        optionMenu.addAction(onlyGroup)
        optionMenu.addAction(cancelAction)
        
        // 5
//        used to persent shit over initial vc
//        UIApplication.shared.delegate?.window??.rootViewController?.present(optionMenu, animated: true, completion: nil)
    
        UIApplication.topViewController()?.present(optionMenu, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
}




