//
//  SegmentControlX.swift
//  Wanto
//
//  Created by Turner Thornberry on 11/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import Foundation
import UIKit

class SegmentedControlX: UISegmentedControl {
    
    let selectedBackgroundColor = UIColor(red: 19/255, green: 59/255, blue: 85/255, alpha: 0.5)
    var sortedViews: [UIView]!
    var currentIndex: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        sortedViews = self.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        
        changeSelectedIndex(to: currentIndex)
        
        self.tintColor = UIColor.white
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        let unselectedAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                    NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)]
        self.setTitleTextAttributes(unselectedAttributes, for: .normal)
        self.setTitleTextAttributes(unselectedAttributes, for: .selected)
    }
    
    func changeSelectedIndex(to newIndex: Int) {
        sortedViews[currentIndex].backgroundColor = UIColor.clear
        currentIndex = newIndex
        self.selectedSegmentIndex = UISegmentedControlNoSegment
        sortedViews[currentIndex].backgroundColor = selectedBackgroundColor
    }
}
