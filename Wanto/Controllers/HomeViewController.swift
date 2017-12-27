//
//  HomeViewController.swift
//  Wanto
//
//  Created by Turner Thornberry on 11/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class HomeViewController: UITableViewController, saveNewDelegate, saveDelegate, goDelegate, cancelDelegate, returnToInactiveDelegate {
  
  
    
    //MARK: Database ref
    var ref: DatabaseReference!
    var refHandle: UInt!
    let userID: String = (Auth.auth().currentUser?.uid)!
    
    var countdownValue: Double?
    
    //MARK: Protocol stubs
    func saveNewActivity(data: Activity) {
        //inactiveActivities.append(data)
        self.tableView.reloadData()
    }
    func saveActivity(data: Activity) {
        inactiveActivities[(self.tableView.indexPathForSelectedRow!.row)] = data
        self.tableView.reloadData()
    }
    func passTimerData(data: Activity, countdownValue: Double, selectedCellIndex: Int) {
        

        if selectedCellIndex != -1 {
            //activeActivities[(self.tableView.indexPathForSelectedRow!.row)].countdownValue = data.countdownValue
            activeActivities.append(data) // appends item to acitive array
            inactiveActivities.remove(at: selectedCellIndex)
            self.tableView.reloadData()
        }
//
    }
    
    func cancel(data: Activity, selectedCellIndex: Int) {
        activeActivities.remove(at: selectedCellIndex)
        inactiveActivities.insert(data, at: 0)
        self.tableView.reloadData()
    }
    func activeToInactive(data: Activity) {
        if let i = activeActivities.index(where: { $0.isActive == false }) {
            print("array index to remove: should be where it is NOT active = \(i)")
            activeActivities.remove(at: i)
        }
        inactiveActivities.insert(data, at: 0)
//        let indexPath = IndexPath(row: 1, section: 0)
        //self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        self.tableView.reloadData()
    }
       // activeActivities.remove(at: 0)
//        activeActivities.remove(at: index(ofAccessibilityElement: data.isActive = false))
       
        //self.tableView.reloadSections([0], with: UITableViewRowAnimation.automatic)
        //self.tableView.reloadData()
        //self.tableView.reloadSections([0], with: UITableViewRowAnimation.automatic)
        
//        let students = ["Kofi", "Abena", "Peter", "Kweku", "Akosua"]
//        if let i = students.index(where: { $0.hasPrefix("A") }) {
//            print("\(students[i]) starts with 'A'!")
//        }
    
    
  
    
    private let inactiveIdentifer = "InactiveCell"
    private let activeIdentifier = "ActiveCell"
    private let tutorialHeader = "TutorialHeader"
    
    var inactiveActivities = [Activity]()
    var activeActivities = [Activity]()
    var timer = Timer()
    
    @IBAction func cancelClick(_ sender: UIButtonX) {
        let alertController = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
            alert -> Void in
            self.ref = Database.database().reference().child("Users/\(self.userID)/Activities")
            let indexPath = self.tableView.indexPathForView(view: sender)!
            self.activeActivities[indexPath.row].isActive = false
            self.activeActivities[indexPath.row].countdownValue = 0
                self.ref.child(self.activeActivities[indexPath.row].id).setValue(["id": self.activeActivities[indexPath.row].id,
                                                                              "name": self.activeActivities[indexPath.row].name,
                                                                              "isActive": self.activeActivities[indexPath.row].isActive,
                                                                              "locString": self.activeActivities[indexPath.row].locationString,
                                                                              "locLat": self.activeActivities[indexPath.row].locLat,
                                                                              "locLong": self.activeActivities[indexPath.row].locLong,
                                                                              "privacySetting": self.activeActivities[indexPath.row].privacySetting])
            self.inactiveActivities.insert(self.activeActivities[indexPath.row], at: 0)
            self.activeActivities.remove(at: indexPath.row)
            self.tableView.reloadData()
        })
        
        
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        
        //add actions to alert sheet
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func fetchActivities() {
        ref.child("Users").child(userID).child("Activities").observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let dbActivity = Activity(id: String(),
                                          name: String(),
                                          isActive: Bool(),
                                          privacySetting: String(),
                                          people: [Person](),
                                          locationString: String(),
                                          locationCoords: CLLocationCoordinate2D(),
                                          locLat: Double(),
                                          locLong: Double(),
                                          countdownValue: Double(),
                                          timerIsRunning: Bool())
                
                //gets data from db
                let dbID = dict["id"] as? String ?? "id not found"
                let dbName = dict["name"] as? String ?? "name not found"
                let dbIsActive = dict["isActive"] as? Bool ?? false
                let dblocString = dict["locString"] as? String ?? "location not found"
                let dblocLat = dict["locLat"] as? Double ?? 0
                let dblocLong = dict["locLong"] as? Double ?? 0
                let dbPrivacy = dict["privacySetting"] as? String ?? "Error"
                let dbCountdown = dict["countdownValue"] as? Double ?? 00
                let dbtimerIsRunning = dict["timerIsRunning"] as? Bool ?? false
                
                
                //setting the data to new activity
                dbActivity.id = dbID
                dbActivity.name = dbName
                dbActivity.isActive = dbIsActive
                dbActivity.locationString = dblocString
                dbActivity.locLat = dblocLat
                dbActivity.locLong = dblocLong
                dbActivity.privacySetting = dbPrivacy
                let dbLocCoords = CLLocationCoordinate2DMake(dblocLat, dblocLong)
                dbActivity.locationCoords = dbLocCoords
                dbActivity.countdownValue = dbCountdown
                dbActivity.timerIsRunning = dbtimerIsRunning
                
                if dbActivity.isActive == true {
                    self.activeActivities.append(dbActivity)
                } else {
                    self.inactiveActivities.append(dbActivity)
                }
                //self.tableView.reloadData()
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchActivities()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //db deletion
            let activityID = self.inactiveActivities[indexPath.row].id
            
            ref.child("Users").child(userID).child("Activities").child(activityID).removeValue()
            
            
            inactiveActivities.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if activeActivities.count != 0 {
            return 2
        }
        if inactiveActivities.count != 0 {
            return 1
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of Activities: \(activeActivities.count)")
        if section == 0 && activeActivities.count != 0 {
            return activeActivities.count
        } else {
            return inactiveActivities.count
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let inactiveCell = tableView.dequeueReusableCell(withIdentifier: inactiveIdentifer , for: indexPath) as! InactiveCell
        let activeCell = tableView.dequeueReusableCell(withIdentifier: activeIdentifier, for: indexPath) as! ActiveCell
        
        if indexPath.section == 0 && self.activeActivities.count != 0  {
            activeCell.name.text = self.activeActivities[indexPath.row].name
            activeCell.location.text = self.activeActivities[indexPath.row].locationString
            activeCell.activity = self.activeActivities[indexPath.row]
            activeCell.returnToInactiveDelegate = self
            if activeCell.activity.isActive == true && activeCell.timerIsRunning == false {
                activeCell.activity.countdownValue = self.activeActivities[indexPath.row].countdownValue
                print(String(self.activeActivities[indexPath.row].countdownValue))
                activeCell.handleCountdown()
            } else if activeCell.timerIsRunning == true {
                activeCell.timer.invalidate()
                activeCell.timerIsRunning = false
                let cellStartTime = activeCell.startTime
                activeCell.activity.countdownValue = cellStartTime
                print("continuing from start time: " + String(cellStartTime))
                activeCell.startTime = cellStartTime
                activeCell.handleCountdown()
                
            }
            //activeCell.countdownTimer.text = String(self.activeActivities[indexPath.row].countdownValue)
            //activeCell.countdownTimer.text = self.activeActivities[indexPath.row].
            
            
            return activeCell
           
        } else if inactiveActivities.count != 0 && inactiveActivities[indexPath.row].isActive == false {
            inactiveCell.name.text = self.inactiveActivities[indexPath.row].name
            inactiveCell.location.text = self.inactiveActivities[indexPath.row].locationString
            inactiveCell.activity = self.inactiveActivities[indexPath.row]
            inactiveCell.showLocInMiniMap(coordinates: self.inactiveActivities[indexPath.row].locationCoords)
            inactiveCell.privacySetting.setTitle(inactiveActivities[indexPath.row].privacySetting, for: .normal)
            return inactiveCell
        }
        return UITableViewCell()
    
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if inactiveActivities.count == 0 && activeActivities.count == 0 {
            let tutorialCell = tableView.dequeueReusableCell(withIdentifier: tutorialHeader) as! TutorialCell
            ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["Name"] as! String
                tutorialCell.tutHeaderLabel.text = "Welcome, \(name). Tap (+) to get started..."

            })
            return tutorialCell
        }
        
        if section == 0 && activeActivities.count != 0 {
            return tableView.dequeueReusableCell(withIdentifier: "ActiveHeader")
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "InactiveHeader")
        }
        
        //        if section == 0 {
        //            return tableView.dequeueReusableCell(withIdentifier: "ActiveHeader")
        //        } else {
        //            return tableView.dequeueReusableCell(withIdentifier: "InactiveHeader")
        //        }
    }
    
    
    
    
    
    @IBAction func goButtonClick(_ sender: UIButtonX) {
        print("go button ckiclked")
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addActivity" {
            let inactiveVC = segue.destination as! InactiveViewController
            inactiveVC.newSaveDelegate = self
            inactiveVC.goDelegate = self
            inactiveVC.selectedCellIndex = -1
        }
        
        if segue.identifier == "selectedInactiveCell"{
            let selectedCellIndex = self.tableView.indexPathForSelectedRow!.row
            
            let inactiveVC = segue.destination as! InactiveViewController
            inactiveVC.editSaveDelegate = self
            inactiveVC.newActivity = inactiveActivities[selectedCellIndex]
            inactiveVC.goDelegate = self
            inactiveVC.selectedCellIndex = selectedCellIndex
            
        }
        
        if segue.identifier == "goClick"{
            //let selectedCellIndex = self.tableView.indexPathForSelectedRow!.row
            //let activeVC = segue.destination as! ActiveViewController
        }
        
        if segue.identifier == "selectedActiveCell"{
            let selectedCellIndex = self.tableView.indexPathForSelectedRow!.row

            let activeVC = segue.destination as! ActiveViewController
            activeVC.activity = activeActivities[selectedCellIndex]
            activeVC.selectedCellIndex = selectedCellIndex
            activeVC.cancelDelegate = self
        }
        
    }
    
    
    
    
}
