//
//  TagDetailViewController.swift
//  AddNewTag
//
//  Created by DJuser on 1/17/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import FirebaseDatabase
import IQKeyboardManagerSwift
import FirebaseStorage

class TagDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {

    
    @IBOutlet weak var TagNamefield: UITextField!
    @IBOutlet weak var TagDescribeView: UITextView!
    
    @IBOutlet weak var myswitch: UISwitch!
   
    @IBOutlet weak var mynotidistance: UILabel!
    var mynotipickerview: UIPickerView!
    var notirange: [String]!
    
    var tagname: String = ""
    var tagdescribe: String = ""
    var Tagnotidistance = ""
    
    let ref = FIRDatabase.database().reference().child("TagsDetail")
    
    //function to put image to firebase storage
    //var storageref = FIRStorage.storage().reference().put(<#T##uploadData: Data##Data#>, metadata: <#T##FIRStorageMetadata?#>, completion: <#T##((FIRStorageMetadata?, Error?) -> Void)?##((FIRStorageMetadata?, Error?) -> Void)?##(FIRStorageMetadata?, Error?) -> Void#>)

    override func viewDidLoad() {
        super.viewDidLoad()
        mynotipickerview.frame = CGRect(x: 0, y: 430, width: self.view.bounds.width, height: 100)
        
    }
    
    
    // total number of column(components)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // total number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notirange[row]
    }
    
    @IBAction func triggerswitch(_ sender: Any) {
        if myswitch.isOn {
            mynotipickerview.showsSelectionIndicator = true
            mynotipickerview.delegate = self
            mynotipickerview.dataSource = self
            notirange = ["Immediate", "Near", "Far"]
            self.view.addSubview(mynotipickerview)
        }
        else {
            
            mynotipickerview.delegate = self
            mynotipickerview.dataSource = self
            //self.view.addSubview(mynotipickerview)
            notirange = ["", "", ""]
        }

    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if myswitch.isOn {
            mynotidistance.text = notirange[row]
            Tagnotidistance = mynotidistance.text!
        }
    }
    
    
    
    @IBAction func selectpicturedidtouch(_ sender: Any) {

        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "imagesourcenavigate") as! UINavigationController
       
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        appdelegate.window?.rootViewController = navigationVC
    }
    
    
    // back button to AddNewTag page
    @IBAction func Backdidtouch(_ sender: Any) {
        
        // switch view by setting navigation controller as root view controller
        // Create a main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // From main storyboard instantiate a view controller
        let ViewController = storyboard.instantiateViewController(withIdentifier: "AddNewTagViewController") as! ViewController

        // Get the app delegate
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Set Navigation Copntroller as root view controller
        appdelegate.window?.rootViewController = ViewController
        
    }
    

    @IBAction func Donedidtouch(_ sender: Any) {
        let tagdetailref = ref.childByAutoId()
        
        tagname = TagNamefield.text!
        tagdescribe = TagDescribeView.text!
        
        let tagdetailValue = [
            "TagName": tagname,
            "TagDescription": tagdescribe,
            "TagNotiDistance": Tagnotidistance,
        ] as [String : Any]
        
        tagdetailref.setValue(tagdetailValue)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
