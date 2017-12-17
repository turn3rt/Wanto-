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

class HomeViewController: UITableViewController, saveNewDelegate, saveDelegate, goDelegate {
  
    
    //MARK: Database ref
    var ref: DatabaseReference!
    var refHandle: UInt!
    let userID: String = (Auth.auth().currentUser?.uid)!
    
    //MARK: Protocol stubs
    func saveNewActivity(data: Activity) {
        //inactiveActivities.append(data)
        self.tableView.reloadData()
    }
    func saveActivity(data: Activity) {
        inactiveActivities[(self.tableView.indexPathForSelectedRow!.row)] = data
        print("edited shit:" , data)
        self.tableView.reloadData()
    }
    
    
    func passTimerData(data: Activity, initialCount: Int) {
        print("PASS TIMER DATA FUNC CALLED")
        activeActivities.append(data)
        self.tableView.reloadData()
    }
    
    private let inactiveIdentifer = "InactiveCell"
    private let activeIdentifier = "ActiveCell"
    private let tutorialHeader = "TutorialHeader"
    
    var inactiveActivities = [Activity]()
    
    var activeActivities = [Activity]()
    
    
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
                                          locLong: Double())
                
                //gets data from db
                let dbID = dict["id"] as? String ?? "id not found"
                let dbName = dict["name"] as? String ?? "name not found"
                let dbIsActive = dict["isActive"] as? Bool ?? false
                let dblocString = dict["locString"] as? String ?? "location not found"
                let dblocLat = dict["locLat"] as? Double ?? 0
                let dblocLong = dict["locLong"] as? Double ?? 0
                let dbPrivacy = dict["privacySetting"] as? String ?? "Error"
                
                
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
                
                if dbActivity.isActive == true {
                    self.activeActivities.append(dbActivity)
                } else {
                    self.inactiveActivities.append(dbActivity)
                }
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
            
            print(";LKAJS;DLJASFJSLJ", indexPath.row)
            print("ACTIVITY ID: ", inactiveActivities[indexPath.row].name)
            print("WTF: ", inactiveActivities[indexPath.row].id)
            
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
        print("Number of Activities: \(inactiveActivities.count)")
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
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if inactiveActivities.count == 0{
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
        }
        
        if segue.identifier == "selectedInactiveCell"{
            let selectedCellIndex = self.tableView.indexPathForSelectedRow!.row
            
            let inactiveVC = segue.destination as! InactiveViewController
            inactiveVC.editSaveDelegate = self
            inactiveVC.newActivity = inactiveActivities[selectedCellIndex]
            inactiveVC.goDelegate = self
            
        }
        
        if segue.identifier == "goClick"{
            //let selectedCellIndex = self.tableView.indexPathForSelectedRow!.row
            let activeVC = segue.destination as! ActiveViewController
        }
        
       // if segue.iden
        
    }
    
    
    
    
}
