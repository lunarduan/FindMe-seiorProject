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
        
      //All below is tab bar attributes
        //self.tabBar.delegate = self
        self.tabBar.barTintColor = .lightGray
        self.tabBar.unselectedItemTintColor = .darkGray
        //self.tabBar.backgroundImage = UIImage(named: "nnnnnn.png")
        //self.tabBar.shadowImage = nil
        
        //set initial selected tab button to home(index 0)
        //self.selectedIndex = 0
    }

    
    // called when any tab button has been pressed
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //print(item.title)
        self.tabBarController?.selectedIndex = item.tag
    }

}
