//
//  homeViewController.swift
//  FindMe
//
//  Created by DJuser on 1/31/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit

class homeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func logoutdidtouch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let logout = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        appdelegate .window?.rootViewController = logout
    }

}
