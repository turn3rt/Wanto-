//
//  SettingsController.swift
//  Wanto
//
//  Created by Turner Thornberry on 12/2/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    @IBOutlet weak var radius: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var privacyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radius.text = "\(Int(slider.value)) miles"
        
    

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }



    @IBAction func sliderDidChange(_ sender: UISlider) {
        radius.text = "\(Int(sender.value)) miles"
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
    

}
