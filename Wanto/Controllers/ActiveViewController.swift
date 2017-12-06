//
//  ActiveViewController.swift
//  Wanto
//
//  Created by Turner Thornberry on 11/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit
import ContactsUI
import Contacts
import CoreLocation


protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

protocol saveDelegate {
    func saveNewActivity(data: Activity)
}

class ActiveViewController: UIViewController, CNContactPickerDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    private let personIdentifier = "Person"
    private let noPersonIdentifier = "NoPerson"
    
    //this is the activity that gets stored and passsed back thorugh the delegate func
    var newActivity = Activity(name: String(), people: [String](), locationString: String())
    
    let locationManager = CLLocationManager()
    var locString = "Add location..."
    
    @IBOutlet weak var peopleCollection: UICollectionView!
    @IBOutlet weak var navigationTitle: UIButton!
    @IBOutlet weak var timeDateSwitch: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var mapLocationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    
    var people = [String]() //["Sally", "Alvaro", "Quinn", "Natalie", "Fernanda", "Cole", "Nick", "Ian", "Reid"] - test data
    
    var delegate: saveDelegate? = nil
    
    @IBAction func titleButtonTap(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add activity name:", message: "", preferredStyle: .alert)
        
        //add text field
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter name..."
        }
        
        
        //change title to entered text
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0] // this is the text that is grabbed from text field
            
            //stores new name for new activity
            self.newActivity.name = textField.text!
            
            print("New activity name: \(String(describing: self.newActivity.name))")
            self.navigationTitle.setTitle(textField.text, for: UIControlState.normal)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        
        //add actions to alert sheet
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func switchValue(_ sender: UISegmentedControl) {
        if timeDateSwitch.selectedSegmentIndex == 0 {
            datePicker.datePickerMode = .countDownTimer
        } else if timeDateSwitch.selectedSegmentIndex == 1 {
            datePicker.datePickerMode = .dateAndTime
        }
    }
    
    
    @IBAction func addPeopleClick(_ sender: UIButtonX){
        let entitiyType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entitiyType)
        
        if authStatus == .notDetermined {
            let contactsStore = CNContactStore.init()
            contactsStore.requestAccess(for: entitiyType, completionHandler: { (success, nil) in
                if success {
                    self.openContacts()
                } else {
                    //@TODO: add action sheet to take user directly to settings
                    print("not authorized")
                }
            })
        }
        else if authStatus == .authorized {
            openContacts()
        }
    }
    
    func openContacts() {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        //@TODO: need to hide status bar
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    //MARK: Delegate Functions for CNContactPickerVC
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // do something with contact
        
        // this is for the full name
        let fullname = "\(contact.givenName) \(contact.familyName)"
        print("The selected name is: \(fullname)")
        
        //adds data to new activity model for prep to send back to home vc
        newActivity.people.append(fullname)
        print("the people in the new activity array are: \(newActivity.people)")
        
        people.append(contact.givenName)
        //print("Collection view data array: \(people)")
        peopleCollection.reloadData()
        
        
        //this one is for getting first number with dashshes in it
        //let phoneNumber =  ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value") as AnyObject).value(forKey: "stringValue")) ?? "No Number Listed" // returns string value of phone number without all the bullshit
        
        //@TODO: error handle if phone number does not exist
        let phoneNumber = contact.phoneNumbers[0].value.stringValue
        print("The selected phone num is: \(phoneNumber)")
        
        
        
        //this is for phone number without dashes
        //print("the selected phone number is: \((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)")
    }
    
    
    
    
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    @IBAction func addLocationClick(_ sender: UIButton) {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        locationSearchTable.mapView = self.mapView
        locationSearchTable.handleMapSearchDelegate = self
        present(resultSearchController!, animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.02, 0.02)
        let userLoc: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(userLoc, span)
        
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func zoomToLocClick(_ sender: Any) {
        let geoocoder = CLGeocoder()
        locationManager.startUpdatingLocation()
        
        let location = locationManager.location! //current user loc
        
        //add annotation to user loc
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.removeAnnotations(mapView.annotations) //removes any remaining annotations
        mapView.addAnnotation(annotation)
        
        //zoom to the loc
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.02, 0.02)
        let userLoc: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(userLoc, span)
        
        geoocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
        //display
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            locationLabel.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                if #available(iOS 11.0, *) {
                    let addressString = placemark.postalAddress?.street
                    locationLabel.text = addressString!
                    
                    //assign new loc string to new ativity var
                    newActivity.locationString = addressString!
                    print("\(newActivity.locationString)")
                } else {
                    //fallback on earlier
                }
            } else {
                locationLabel.text = "No Matching Addresses Found"
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if locString != "Add location..." {
            locationLabel.text = locString
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func privacyButtonClick(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "People who can see your activity", preferredStyle: .actionSheet)
        
        // 2
        let everyone = UIAlertAction(title: "Everyone", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Tapped Everyone")
            self.privacyButton.titleLabel?.text = "Everyone"
            
        })
        let friends = UIAlertAction(title: "Friends", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("tapped friends")
            self.privacyButton.titleLabel?.text = "Friends"
            
        })
        let onlyGroup = UIAlertAction(title: "Only Group", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("tapped only group")
            self.privacyButton.titleLabel?.text = "Only Group"
            
            
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
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func saveClick(_ sender: UIButtonX) {
        print("New acitivity is: \(String(describing: newActivity.name))")
        
        //check if delegate exists
        if delegate != nil {
            //the delegate need to take a type of new acdtivity data, of type activity class to do the func in protocol
            delegate?.saveNewActivity(data: newActivity)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
}


extension ActiveViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of People: \(people.count)")
        if people.count == 0{
            return 1
        } else {
            return people.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if people.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noPersonIdentifier, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: personIdentifier, for: indexPath) as! PersonCell
            cell.name.text = people[indexPath.row]
            return cell
        }
    }
    
    
    
    
}

extension ActiveViewController: HandleMapSearch{
    func dropPinZoomIn(placemark:MKPlacemark){
        
        // cache the pin
        selectedPin = placemark
        
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        //add location to delegate new activity
        newActivity.locationString = placemark.name!
        print("new activity location: \(String(describing: placemark.name))")
        locationLabel.text = placemark.name
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        
        mapView.setRegion(region, animated: true)
    }
}

//extension ActiveViewController: MKMapViewDelegate {
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
//        if annotation is MKUserLocation {
//            //return nil so map view draws "blue dot" for standard user location
//            return nil
//        }
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        pinView?.canShowCallout = false
//        return pinView
//    }
//} 

