//
//  HomeViewController.swift
//  Wanto
//
//  Created by Turner Thornberry on 11/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UITableViewController, saveNewDelegate, saveDelegate {
    
    private let inactiveIdentifer = "InactiveCell"
    private let activeIdentifier = "ActiveCell"
    private let tutorialHeader = "TutorialHeader"
    
    var inactiveActivities = [Activity]() //["Gym" , "Study", "Meeting", "Lunch" , "Party", "Study Aerodynamics", "Boof Seminar"]
    var activeActivies = [Activity]()
    
    var locations = [String]() //["Southwest Recreation Center", "Library West", "Little Hall" , "Chipotle", "The Standard", "Marston Science Library", "Uranus"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            inactiveActivities.remove(at: indexPath.row)
            self.tableView.reloadData()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func saveNewActivity(data: Activity) {
        inactiveActivities.append(data)
        self.tableView.reloadData()
    }
    func saveActivity(data: Activity) {
        inactiveActivities[(self.tableView.indexPathForSelectedRow!.row)] = data
        print("edited shit:" , data)
        self.tableView.reloadData()
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
        
        if indexPath.section == 0 && inactiveActivities.count != 0 {
            inactiveCell.name.text = self.inactiveActivities[indexPath.row].name
            inactiveCell.location.text = self.inactiveActivities[indexPath.row].locationString
            inactiveCell.activity = self.inactiveActivities[indexPath.row]
            inactiveCell.showLocInMiniMap(coordinates: inactiveActivities[indexPath.row].locationCoords)
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
            return tableView.dequeueReusableCell(withIdentifier: tutorialHeader)
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
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
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
