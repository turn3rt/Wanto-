//
//  Helper.swift
//  Wanto
//
//  Created by Turner Thornberry on 11/30/17.
//  Copyright © 2017 Turner Thornberry. All rights reserved.
//

import Foundation
import UIKit


class Helper {
  let BASE_URL = "https://wanto-2024t.firebaseio.com/"
    
    
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



