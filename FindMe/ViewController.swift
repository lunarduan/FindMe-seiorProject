//
//  ViewController.swift
//  FindMe
//
//  Created by DJuser on 1/30/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITabBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // when pressed Login button, you will go to registrationViewController
    @IBAction func logindidtouch(_ sender: Any) {
    
        self.performSegue(withIdentifier: "login", sender: nil)
    
    }
    
    

}

