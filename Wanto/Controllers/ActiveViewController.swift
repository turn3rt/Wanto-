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
import Firebase


protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

protocol saveNewDelegate {
    func saveNewActivity(data: Activity)
}

protocol saveDelegate{
    func saveActivity(data: Activity)
}
class ActiveViewController: UIViewController, CNContactPickerDelegate, CLLocationManagerDelegate, UISearchBarDelegate, personDeleteDelegate, reorderDelegate {
    //MARK: Database ref
    var ref: DatabaseReference!
    var activitiesRef: DatabaseReference!
    var refHandle: UInt!
    let userID: String = (Auth.auth().currentUser?.uid)!

    //MARK: Protocol Stubs
    func deletePerson(atIndexPath: Int) {
        print("activity index to remove: " , atIndexPath)
        newActivity.people.remove(at: atIndexPath)
        self.peopleCollection.reloadData()
    }
    func reorder(activity: Activity) {
        newActivity.people = activity.people
        self.peopleCollection.reloadData()
    }
    
    
    
    private let personIdentifier = "Person"
    private let noPersonIdentifier = "NoPerson"
    
    //this is the activity that gets stored and passsed back thorugh the delegate func
    var newActivity = Activity(id: String(),
                               name: "Add name...",
                               privacySetting: "Friends",
                               people: [Person](),
                               locationString: "Add location...",
                               locationCoords: CLLocationCoordinate2D(),
                               locLat: Double(),
                               locLong: Double()
                                )

    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var peopleCollection: UICollectionView!
    @IBOutlet weak var navigationTitle: UIButton!
    @IBOutlet weak var timeDateSwitch: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var mapLocationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var newSaveDelegate: saveNewDelegate? = nil
    var editSaveDelegate: saveDelegate? = nil
    
    
    
    
   
    
    @IBAction func titleButtonTap(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add activity name:", message: "", preferredStyle: .alert)
        
        //add text field
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter name..."
            textField.autocapitalizationType = UITextAutocapitalizationType.words
        }
        
        
        //change title to entered text
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0] // this is the text that is grabbed from text field
            
            print("New activity name: \(String(describing: self.newActivity.name))")
            self.newActivity.name = textField.text!
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
        let contactPicker = CNContactPickerViewController()
        let numKeys = [CNContactPhoneNumbersKey]
        contactPicker.displayedPropertyKeys = numKeys
        contactPicker.delegate = self
        //@TODO: need to hide status bar
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    //MARK: Delegate Functions for CNContactPickerVC
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let newPerson = Person(firstName: contact.givenName,
                               lastName: contact.familyName,
                               profileImage: #imageLiteral(resourceName: "capitalizing_on_the_economic_potential_of_foreign_entrepreneurs_feature.png") )
        
        if newActivity.people.contains(where: { $0.firstName == newPerson.firstName && $0.lastName == newPerson.lastName}) {
            print("Person Already added error")
            let alertController = UIAlertController(title: "Error: Person already added!", message: "", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: {
                alert -> Void in
            })
            
            //alertController.addAction(confirmAction)
            picker.present(alertController, animated: true, completion: nil)
        } else {
            if contact.imageDataAvailable == true {
                newPerson.profileImage = UIImage(data: contact.imageData!)!
            }
            
            // this is for the full name
            let fullname = "\(contact.givenName) \(contact.familyName)"
            print("The selected name is: \(fullname)")
//            let phoneNum = contact.phoneNumbers.first?.value.stringValue
//            print("The selected phone num is: \(phoneNum!)")
            
            //appends data to new activity model for prep to send back to home vc
            newActivity.people.append(newPerson)
            print("the people in the new activity array are: \(newActivity.people)")
            
            peopleCollection.reloadData()
            
        }
        
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
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
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
        newActivity.locationCoords = location.coordinate
        newActivity.locLat = location.coordinate.latitude
        newActivity.locLong = location.coordinate.longitude
        
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            locationLabel.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks,
                let placemark = placemarks.first {
                if #available(iOS 11.0, *) {
                    let addressString = placemark.postalAddress?.street
                    locationLabel.text = addressString!
                    
                    //assign new loc string to new activity var
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
        
        //sets database refs
        ref = Database.database().reference()
        activitiesRef = Database.database().reference().child("Users/\(userID)/Activities")

        
        if newActivity.name != "Add name..."{
            navigationTitle.setTitle(newActivity.name, for: .normal)
        }
        
        if newActivity.locationString != "Add location..." {
            locationLabel.text = newActivity.locationString
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = newActivity.locationCoords
            annotation.title = newActivity.locationString
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(annotation.coordinate, span)
            
            mapView.setRegion(region, animated: true)

        } else {
            locationManager.startUpdatingLocation()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activitySettings" {
            let settingsVC = segue.destination as! activitySettingsController
            settingsVC.activity = self.newActivity
            settingsVC.deleteDelegate = self
            settingsVC.reorderDelegate = self
        }

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
        if newActivity.name == "Add name..."{
            let alertController = UIAlertController(title: "Add activity name!", message: "", preferredStyle: .alert)
            
            //add text field
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter name..."
                textField.autocapitalizationType = UITextAutocapitalizationType.words
            }
            
            
            //change title to entered text
            let confirmAction = UIAlertAction(title: "Ok!", style: .default, handler: {
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
    
        if newActivity.locationString == "Add location..."{
            let alertController = UIAlertController(title: "Add location!", message: "", preferredStyle: .alert)
            
            //add text field
           
            
            //change title to entered text
            let confirmAction = UIAlertAction(title: "OK!", style: .default, handler: {
                alert -> Void in
            })
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action : UIAlertAction!) -> Void in
                
            })
            
            
            //add actions to alert sheet
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        if newActivity.people.count == 0 {
            let alertController = UIAlertController(title: "Add at least one person!", message: "", preferredStyle: .alert)
      
            let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {
                alert -> Void in
            })
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (action : UIAlertAction!) -> Void in
                
            })
            
            
            //add actions to alert sheet
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
        if newActivity.name != "Add name..." && newActivity.locationString != "Add location..." && newActivity.people.count != 0 {
            //check if delegate exists
            if newSaveDelegate != nil {
                //the delegate need to take a type of new acdtivity data, of type activity class to do the func in protocol
                newSaveDelegate?.saveNewActivity(data: newActivity)
                let key = activitiesRef.childByAutoId().key
                newActivity.id = key
                let activityToAdd = ["id": newActivity.id,
                                     "name": newActivity.name,
                                     "locString": newActivity.locationString,
                                     "locLat": newActivity.locLat,
                                     "locLong": newActivity.locLong,
                    
                    ] as [String : Any]
                activitiesRef.child(key).setValue(activityToAdd)
                print("Activity saved to database & local: ", activityToAdd)
            }
            
            if editSaveDelegate != nil {
                editSaveDelegate?.saveActivity(data: newActivity)
                let activityKey = activitiesRef.key
                print("Activity key is: ", activityKey)
                activitiesRef.child(newActivity.id).setValue([ "id": newActivity.id,
                                                               "name": newActivity.name,
                                                               "locString": newActivity.locationString,
                                                               "locLat": newActivity.locLat,
                                                               "locLong": newActivity.locLong])
            }
            
            
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}


extension ActiveViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of People in \(newActivity.name): \(newActivity.people.count)")
        if newActivity.people.count == 0{
            return 1
        } else {
            return newActivity.people.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if newActivity.people.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noPersonIdentifier, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: personIdentifier, for: indexPath) as! PersonCell
            cell.name.text = newActivity.people[indexPath.row].firstName
            cell.profileImage.image = newActivity.people[indexPath.row].profileImage
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
        newActivity.locationCoords = placemark.coordinate
        newActivity.locLat = placemark.coordinate.latitude
        newActivity.locLong = placemark.coordinate.longitude
        
        print("new activity location: \(String(describing: placemark.name))")
        locationLabel.text = placemark.name
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        
        mapView.setRegion(region, animated: true)
    }
}


