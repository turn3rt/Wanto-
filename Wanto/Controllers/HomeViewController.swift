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

class HomeViewController: UITableViewController, saveNewDelegate, saveDelegate {
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
    
    private let inactiveIdentifer = "InactiveCell"
    private let activeIdentifier = "ActiveCell"
    private let tutorialHeader = "TutorialHeader"
    
    var inactiveActivities = [Activity]()
    
    var activeActivies = [Activity]()
    
    
    func fetchActivities() {
        ref.child("Users").child(userID).child("Activities").observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                //gets data from db
                let dbActivity = Activity(id: String(),
                                          name: "Add name...",
                                          privacySetting: "Friends",
                                          people: [Person](),
                                          locationString: "Add location...",
                                          locationCoords: CLLocationCoordinate2D(),
                                          locLat: Double(),
                                          locLong: Double())
                
                
                let dbID = dict["id"] as? String ?? "id not found"
                let dbName = dict["name"] as? String ?? "name not found"
                let dblocString = dict["locString"] as? String ?? "location not found"
                let dblocLat = dict["locLat"] as? Double ?? 0
                let dblocLong = dict["locLong"] as? Double ?? 0
                
//                let dbName = self.value(forKey: "name") as? String ?? "name not found"
//                let dblocString = value["locString"] as? String ?? "locString not found"
//                let dblocLat = value["locLat"] as? Double ?? 0
//                let dblocLong = value["locLong"] as? Double ?? 0
                
                //setting the data to new activity
                dbActivity.id = dbID
                dbActivity.name = dbName
                dbActivity.locationString = dblocString
                dbActivity.locLat = dblocLat
                dbActivity.locLong = dblocLong
                let dbLocCoords = CLLocationCoordinate2DMake(dblocLat, dblocLong)
                dbActivity.locationCoords = dbLocCoords
                
                self.inactiveActivities.append(dbActivity)
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        fetchActivities()
        
//        ref.child("Users").child(userID).child("Activities").observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            //let dbActivities = value?["Activities"]
//            //print(dbActivities)
//        })
        
            
            
            
        
//        refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
//            let dataDict = snapshot.value as! [String: AnyObject]
//            //print(dataDict)
//        })
//
//        ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let name = value?["Name"] as! String
//        })

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
        
        
        if activeActivies.count != 0 {
            return 2
        }
        if inactiveActivities.count != 0 {
            return 1
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of Activities: \(inactiveActivities.count)")
        if section == 0 && inactiveActivities.count != 0 {
            return inactiveActivities.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let inactiveCell = tableView.dequeueReusableCell(withIdentifier: inactiveIdentifer , for: indexPath) as! InactiveCell
        //let activeCell = tableView.dequeueReusableCell(withIdentifier: activeIdentifier, for: indexPath) as! ActiveCell
        // let tutorialCell = tableView.dequeueReusableCell(withIdentifier: tutorialIdentifer, for: indexPath)
        
        if indexPath.section == 0 && self.inactiveActivities.count != 0 {
            
         
            
            
            inactiveCell.name.text = self.inactiveActivities[indexPath.row].name
            inactiveCell.location.text = self.inactiveActivities[indexPath.row].locationString
            inactiveCell.activity = self.inactiveActivities[indexPath.row]
            inactiveCell.showLocInMiniMap(coordinates: self.inactiveActivities[indexPath.row].locationCoords)
            inactiveCell.privacySetting.setTitle(inactiveActivities[indexPath.row].privacySetting, for: .normal)
            return inactiveCell
            
            //else {
            //            inactiveCell.name.text = self.inactiveActivities[indexPath.row].name
            //            inactiveCell.location.text = self.inactiveActivities[indexPath.row].locationString
            //            inactiveCell.activity = self.inactiveActivities[indexPath.row]
            //            inactiveCell.showLocInMiniMap(coordinates: inactiveActivities[indexPath.row].locationCoords)
            //            return inactiveCell
            
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
        
        if section == 0 && activeActivies.count != 0 {
            return tableView.dequeueReusableCell(withIdentifier: "ActiveHeader")
        }
        if section == 0 && inactiveActivities.count != 0 {
            return tableView.dequeueReusableCell(withIdentifier: "InactiveHeader")
        }
        return nil
        
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
            let activeVC = segue.destination as! ActiveViewController
            activeVC.newSaveDelegate = self
        }
        
        if segue.identifier == "selectedInactiveCell"{
            let selectedCellIndex = self.tableView.indexPathForSelectedRow!.row
            
            let inactiveVC = segue.destination as! ActiveViewController
            inactiveVC.editSaveDelegate = self
            inactiveVC.newActivity = inactiveActivities[selectedCellIndex]
            
        }
        
    }
    
    
    
    
}
