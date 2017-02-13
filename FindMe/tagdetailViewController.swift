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

class tagdetailViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tagnamefield: UITextField!
    @IBOutlet weak var tagdesciptionview: UITextView!
    
    @IBOutlet weak var notificationswitch: UISwitch!
   
    //this for picker
    @IBOutlet weak var notificationlabel: UILabel!
    @IBOutlet weak var notificationpickerview: UIPickerView!
    var notirange: [String]!
    
    @IBOutlet weak var mypic: UIImageView!
    var selectedimage = UIImage()
    
    var tagname: String = ""
    var tagdescribe: String = ""
    var Tagnotidistance = ""
    
    //data passing from addnewtagVC
    var usertagid = String()
    
    
    //NSUser
    var tagidKeyConstant = ""
    var tagnameKeyConstant = ""
    var tagdescriptionKeyConstant = ""
    var tagnotidistanceKeyConstant = ""
    var notiswitchKeyConstant = ""
    

    
    let ref = FIRDatabase.database().reference().child("TagsDetail")
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        notificationpickerview.frame = CGRect(x: 0, y: 430, width: self.view.bounds.width, height: 100)
        
        mypic.image = selectedimage
        mypic.sizeToFit()
        mypic.center.x = self.view.center.x
        mypic.center.y = 140
        
        
        //NSUser
        tagidKeyConstant = self.usertagid
        tagnameKeyConstant = "\(tagidKeyConstant)"+"tagnameKey"
        tagdescriptionKeyConstant = "\(tagidKeyConstant)"+"tagdescriptionKey"
        tagnotidistanceKeyConstant = "\(tagidKeyConstant)"+"tagnotidistanceKey"
        notiswitchKeyConstant = "\(tagidKeyConstant)"+"notiswitchKey"
        readData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var dstVC :  tagsymbolsourceCollectionViewController = segue.destination as! tagsymbolsourceCollectionViewController
        
        dstVC.tag = self.usertagid
    }

    
    @IBAction func selectpicturedidtouch(_ sender: Any) {
        //NSUser
        writeData()
        
        self.performSegue(withIdentifier: "symbol", sender: nil)
        
    }
    
    
    //when Done button pressed, app will sent data to firebase database
    @IBAction func donedidtouch(_ sender: Any) {
        
        let tagdetailref = ref.childByAutoId()
        
        tagname = tagnamefield.text!
        tagdescribe = tagdesciptionview.text!
        
        if tagdescribe == nil{
            tagdescribe = ""
        }
        
        //upload tag image to firebase storage
        let imageName = NSUUID().uuidString
        let storageref = FIRStorage.storage().reference().child("tags_images").child("\(imageName).png")
        
        let uploadtagimage = UIImagePNGRepresentation(mypic.image!)
    
        
        storageref.put(uploadtagimage!, metadata: nil) { ( metadata, error) in
            let tagImageUrl = metadata?.downloadURL()?.absoluteString
            
            let tagdetailValue = [
                "tagid": self.usertagid,
                "TagName": self.tagname,
                "TagDescription": self.tagdescribe,
                "TagNotiDistance": self.Tagnotidistance,
                "tagurl": tagImageUrl,
                ] as [String : Any]
            
            tagdetailref.setValue(tagdetailValue)
        }
        
    }
    
    
    @IBAction func notificationswitch(_ sender: Any) {
        if notificationswitch.isOn {
            //these are for picker
            notificationpickerview.showsSelectionIndicator = true
            notificationpickerview.delegate = self
            notificationpickerview.dataSource = self
            notirange = ["Immediate(0 - 20 cm.)", "Near(20 cm. - 2 m.)", "Far(2 - 30 m.)"]
            self.view.addSubview(notificationpickerview)
            //
        }
        else {
            //these are for picker
            notificationpickerview.delegate = self
            notificationpickerview.dataSource = self
            notirange = ["", "", ""]
            //
        }
    
    }
    
    // total number of column(components) for picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // total number of rows for picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    //these are for picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notirange[row]
    }
    
    //these are for picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if notificationswitch.isOn {
            notificationlabel.text = notirange[row]
            Tagnotidistance = notificationlabel.text!
        }
    }
    
    
    // เมื่อกดbackหน้านี้(tagdetailViewContoller)จะลดลง -> จะขึ้นหน้า AddnewrtagViewContoller
    @IBAction func back(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let TagVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate .window?.rootViewController = TagVC
  
    }

    //NSUser after 13/2/2017
    func writeData()
    {
        print("tagnamekey in write")
        print(tagnameKeyConstant)
        let defaults = UserDefaults.standard
        defaults.set(tagnamefield.text, forKey:  tagnameKeyConstant)
        defaults.set(tagdesciptionview.text, forKey:  tagdescriptionKeyConstant)
        defaults.set(notificationlabel.text, forKey:  tagnotidistanceKeyConstant)
        defaults.set(true, forKey:  notiswitchKeyConstant)

    }
    
    func readData()
    {
        print("tagnamekey in read")
        print(tagnameKeyConstant)
            let defaults = UserDefaults.standard
            let name = defaults.string(forKey:  tagnameKeyConstant)
            let descriptions = defaults.string(forKey:  tagdescriptionKeyConstant)
            let notidistance = defaults.string(forKey:  tagnotidistanceKeyConstant)
            let notiswitchstate = defaults.bool(forKey:  notiswitchKeyConstant)
        
            tagnamefield.text = name
            tagdesciptionview.text = descriptions
            notificationswitch.isOn = notiswitchstate
            notificationlabel.text = notidistance
       
        if notidistance == nil{
        }
        else{
            if Tagnotidistance == "" {
                Tagnotidistance = notidistance!
            }
        }
    }
    
    
    
}
