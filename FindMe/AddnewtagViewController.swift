//
//  AddnewtagViewController.swift
//  FindMe
//
//  Created by DJuser on 1/30/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseDatabase
import FirebaseAuth

class AddnewtagViewController: UIViewController, UINavigationControllerDelegate  {

    var uuid:String = ""
    var major:Int = 0
    var minor:Int = 0
    
    @IBOutlet weak var uuidfield: UITextField!
    @IBOutlet weak var majorfield: UITextField!
    @IBOutlet weak var minorfield: UITextField!
    
    //access tag id
    @IBOutlet weak var mysendtext: UILabel!
    var tagid:String!
    //
    
    
    let rootref = FIRDatabase.database().reference().child("Tags")
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //executed when pressed Save button
    @IBAction func gototagdetail(_ sender: Any) {
        
        let newtagconfig = rootref.childByAutoId()
        
        //access tag id
        tagid = newtagconfig.key as String
        
        let userid = FIRAuth.auth()!.currentUser!.uid
        
        uuid = uuidfield.text!
        major = Int(majorfield.text!)!
        minor = Int(minorfield.text!)!
       
        let tagconfigValue = [
            "userid": userid,
            "uuid": uuid,
            "major": major,
            "minor": minor,
        ] as [String : Any]
        
        //save tag data to firebase
        newtagconfig.setValue(tagconfigValue)
        
        //use to connect AddnewtagViewController to tagdetailViewController
        self.performSegue(withIdentifier: "gototagdetail", sender: nil)
    }
    
    
    // when press Logout button you will go to the fisrt page (Login)ViewController
    @IBAction func logoutdidtouch(_ sender: Any) {
        
        try! FIRAuth.auth()!.signOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logout = storyboard.instantiateViewController(withIdentifier: "ViewController") as!ViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate .window?.rootViewController = logout
    
    }
    
    //passing tag data to tagdetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var dstVC :  tagdetailViewController = segue.destination as! tagdetailViewController
        
        dstVC.usertagid = self.tagid
    }
    

    
    
}
