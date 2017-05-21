//
//  addtagViewController.swift
//  FindMe
//
//  Created by DJuser on 1/30/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit

class addtagViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

   
    @IBAction func backdidtouch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
        appdelegate.window?.rootViewController = ViewController
    
    }
    
    
}
