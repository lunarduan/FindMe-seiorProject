//
//  TabBarController.swift
//  FindMe
//
//  Created by DJuser on 1/30/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = .lightGray
        self.tabBar.unselectedItemTintColor = .darkGray
     
    }

    
    // called when any tab button has been pressed
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.tabBarController?.selectedIndex = item.tag
    }

}
