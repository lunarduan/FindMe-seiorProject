//
//  tagdetailViewController.swift
//  FindMe
//
//  Created by DJuser on 1/31/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//
import UIKit
import FirebaseDatabase
import IQKeyboardManagerSwift
import FirebaseStorage

class tagdetailViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var tagnamefield: UITextField!
    @IBOutlet weak var tagdesciptionview: UITextView!
    
    @IBOutlet weak var notificationswitch: UISwitch!
   
    @IBOutlet weak var notificationlabel: UILabel!
    @IBOutlet weak var notificationpickerview: UIPickerView!
    var notirange: [String]!
    
    @IBOutlet weak var mypic: UIImageView!
    var selectedimage = UIImage()
    
    var tagname: String = ""
    var tagdescribe: String = ""
    var Tagnotidistance = ""
    
    
    let ref = FIRDatabase.database().reference().child("TagsDetail")
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationpickerview.frame = CGRect(x: 0, y: 430, width: self.view.bounds.width, height: 100)
        
        mypic.image = selectedimage
        mypic.sizeToFit()
        mypic.center.x = self.view.center.x
        mypic.center.y = 140
        
           }
    
    
    @IBAction func notificationswitch(_ sender: Any) {
        if notificationswitch.isOn {
            notificationpickerview.showsSelectionIndicator = true
            notificationpickerview.delegate = self
            notificationpickerview.dataSource = self
            notirange = ["Immediate", "Near", "Far"]
            self.view.addSubview(notificationpickerview)
        }
        else {
            
            notificationpickerview.delegate = self
            notificationpickerview.dataSource = self
            notirange = ["", "", ""]
        }
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if notificationswitch.isOn {
            notificationlabel.text = notirange[row]
            Tagnotidistance = notificationlabel.text!
        }
    }
    
    
    //when Done button pressed, app will sent data to firebase database
    @IBAction func donedidtouch(_ sender: Any) {
        let tagdetailref = ref.childByAutoId()
     
        let storageref = FIRStorage.storage().reference().child("tagimage.png")

        tagname = tagnamefield.text!
        tagdescribe = tagdesciptionview.text!
        
        if tagdescribe == nil{
            tagdescribe = ""
        }
        
        let tagdetailValue = [
            "TagName": tagname,
            "TagDescription": tagdescribe,
            "TagNotiDistance": Tagnotidistance,
            ] as [String : Any]
        
        tagdetailref.setValue(tagdetailValue)
        
        let uploadtagimage = UIImagePNGRepresentation(mypic.image!)
        storageref.put(uploadtagimage!)
        
    }
    
    @IBAction func selectpicturedidtouch(_ sender: Any) {
        self.performSegue(withIdentifier: "symbol", sender: nil)
    }
    
    
    // เมื่อกดbackหน้านี้(tagdetailViewContoller)จะลดลง -> จะขึ้นหน้า AddnewrtagViewContoller
    @IBAction func back(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let TagVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate .window?.rootViewController = TagVC
  
    }

    
    
}
