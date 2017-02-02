//
//  registrationViewController.swift
//  FindMe
//
//  Created by DJuser on 1/31/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit

class registrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

 
    @IBAction func logoutdidtouch(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
    @IBAction func startdidtouch(_ sender: Any) {
        self.performSegue(withIdentifier: "tabbar", sender: nil)
    }

}
