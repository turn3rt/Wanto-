//
//  InactiveCell.swift
//  Wanto
//
//  Created by Turner Thornberry on 11/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit

class InactiveCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
 
    
    @IBOutlet weak var mapView: MKMapView!
    
    var activity = Activity(name: String(), privacySetting: String(), people: [Person](), locationString: String(), locationCoords: CLLocationCoordinate2D())
    
    func showLocInMiniMap(coordinates: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = activity.locationCoords
        //annotation.title = ""
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.025, 0.05)
        let region = MKCoordinateRegionMake(annotation.coordinate, span)
        
        mapView.setRegion(region, animated: true)
    }
}


