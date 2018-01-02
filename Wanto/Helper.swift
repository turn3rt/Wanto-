//
//  Helper.swift
//  Wanto
//
//  Created by Turner Thornberry on 11/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import JSQMessagesViewController


struct Constants{
    struct refs{
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("Chats")
        static let databaseUsers = databaseRoot.child("Users")
        static let takenUsernames = databaseRoot.child("takenUsernames")
    }
}







class Helper {
  let BASE_URL = "https://wanto-2024t.firebaseio.com/"
    
    
    
    
    
    
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return formatter.string(from: date as Date)
    }
    
    

    
    
    
}

//recursively finds top view controller: used for presenting alerts when no vc is present
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let tabController = controller as? UITabBarController {
            return topViewController(controller: tabController.selectedViewController)
        }
        if let navController = controller as? UINavigationController {
            return topViewController(controller: navController.visibleViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UITableView {
    func indexPathForView(view: AnyObject) -> NSIndexPath? {
        let originInTableView = self.convert(CGPoint(), from: (view as! UIView))
        return self.indexPathForRow(at: originInTableView) as NSIndexPath?
    }
}

extension JSQMessagesInputToolbar {
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if self.window?.safeAreaLayoutGuide != nil {
                self.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow((self.window?.safeAreaLayoutGuide.bottomAnchor)!, multiplier: 1.0).isActive = true
            }
        }
    }
}



