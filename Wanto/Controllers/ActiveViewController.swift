//
//  ActiveViewController.swift
//  Wanto
//
//  Created by Turner Thornberry on 11/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit
import MapKit

class ActiveViewController: UIViewController {
    
    let personIdentifier = "Person"
    let noPersonIdentifier = "NoPerson"
    
    @IBOutlet weak var timeDateSwitch: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var people = ["Sally", "Alvaro", "Quinn", "Natalie", "Fernanda", "Cole", "Nick", "Ian", "Reid"]
    
    
    @IBAction func switchValue(_ sender: UISegmentedControl) {
        if timeDateSwitch.selectedSegmentIndex == 0 {
            datePicker.datePickerMode = .countDownTimer
        } else if timeDateSwitch.selectedSegmentIndex == 1 {
            datePicker.datePickerMode = .dateAndTime
        }
    }
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    
    
    
    
   
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
