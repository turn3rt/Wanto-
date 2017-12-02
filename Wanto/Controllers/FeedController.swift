//
//  FeedController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/1/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit

private let unconfirmedHeader = "UnconfirmedHeader"
private let unconfirmedIdentifer = "UnconfirmedFeedCell"
private let confirmedIdentifier = "ConfirmedFeedCell"
private let confirmedHeader = "ConfirmedHeader"


class FeedController: UITableViewController {
    var people = ["Natalie", "Alvaro", "Quinn", "Natalie", "Fernanda", "Cole", "Nick"]

    
    var activities = ["Art Basel" , "Study", "Meeting", "Lunch" , "Party", "Study Aerodynamics", "Boof Seminar"]
    var locations = ["Mana Convention Center", "Library West", "Little Hall" , "Chipotle", "The Standard", "Marston Science Library", "Uranus"]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let confirmedCell = tableView.dequeueReusableCell(withIdentifier: confirmedIdentifier, for: indexPath) as! FeedCell
        let unconfirmedCell = tableView.dequeueReusableCell(withIdentifier: unconfirmedIdentifer, for: indexPath) as! FeedCell
        
        if indexPath.section == 0 {
            confirmedCell.host.text = people[indexPath.row]
            confirmedCell.name.text = activities[indexPath.row]
            confirmedCell.location.text = locations[indexPath.row]
            return confirmedCell
        } else {
            unconfirmedCell.host.text = people[indexPath.row]
            unconfirmedCell.name.text = activities[indexPath.row]
            unconfirmedCell.location.text = locations[indexPath.row]
            return unconfirmedCell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: confirmedHeader)
        } else {
            return tableView.dequeueReusableCell(withIdentifier: unconfirmedHeader)
        }
    }
 
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 110
//    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
