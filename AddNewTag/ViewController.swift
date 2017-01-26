//
//  ViewController.swift
//  AddNewTag
//
//  Created by DJuser on 1/15/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import FirebaseDatabase
import IQKeyboardManagerSwift

class ViewController: UIViewController {
    
    var uuid:String = ""
    var major:Int = 0
    var minor:Int = 0

    @IBOutlet weak var uuidTextfield: UITextField!
    @IBOutlet weak var majorTextfield: UITextField!
    @IBOutlet weak var minorTextfield: UITextField!
    
    let rootref = FIRDatabase.database().reference().child("NewTagConfig")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func nextdidtouch(_ sender: Any) {
        let newtagconfig = rootref.childByAutoId()
        
        uuid = uuidTextfield.text!
        major = Int(majorTextfield.text!)!
        minor = Int(minorTextfield.text!)!
    
        let tagconfigValue = [
            "uuid": uuid,
            "major": major,
            "minor": minor,
    ] as [String : Any]
    
        newtagconfig.setValue(tagconfigValue)
        
        // switch view by setting navigation controller as root view controller
        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // From main storyboard instantiate
        let navigationViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController") as! UINavigationController
    
        // Get the app delegate
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Set Navigation Copntroller as root view controller
        appdelegate.window?.rootViewController = navigationViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

