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
    
    //*recieve data from locationViewController
    var detail = [String:String]()
    var key = String()
   
   
    //NSUser
    var tagidKeyConstant = ""
    var tagnameKeyConstant = ""
    var tagdescriptionKeyConstant = ""
    var tagnotidistanceKeyConstant = ""
    var notiswitchKeyConstant = ""
 
    
    //NSUser location
    var locationtagidKeyConstant = ""
    var locationtagnameKeyConstant = ""
    var locationtagdescriptionKeyConstant = ""
    var locationtagnotidistanceKeyConstant = ""
    var locationnotiswitchKeyConstant = ""
    

    
    let ref = FIRDatabase.database().reference().child("TagsDetail")
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        notificationpickerview.frame = CGRect(x: 0, y: self.view.bounds.height - 160, width: self.view.bounds.width, height: 90)
        
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

        writeData()
        
        //upload tag image to firebase storage
        let imageName = NSUUID().uuidString
        let storageref = FIRStorage.storage().reference().child("tags_images").child("\(imageName).png")
        
        let img = mypic.image
        
        if mypic.image == nil{
            mypic.image = UIImage(named: "1.png")
        }
        
        var uploadtagimage = UIImagePNGRepresentation(img!)
        
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
        
        let alert = UIAlertController(title: "Edit your tag's detail completed", message: nil, preferredStyle: .alert)
        //let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let TagVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate .window?.rootViewController = TagVC
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion:{})
        
    }
    
    
    @IBAction func notificationswitch(_ sender: Any) {
        if notificationswitch.isOn {
            notificationpickerview.showsSelectionIndicator = true
            notificationpickerview.delegate = self
            notificationpickerview.dataSource = self
            notirange = ["Immediate(0 - 20 cm.)", "Near(20 cm. - 2 m.)", "Far(2 - 30 m.)"]
            self.view.addSubview(notificationpickerview)
            
        }
        else {
            notificationpickerview.delegate = self
            notificationpickerview.dataSource = self
            notirange = ["", "", ""]
            
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

 
    func writeData(){
        let defaults = UserDefaults.standard
        
        defaults.set(tagnamefield.text, forKey:  tagnameKeyConstant)
        defaults.set(tagdesciptionview.text, forKey:  tagdescriptionKeyConstant)
        defaults.set(notificationlabel.text, forKey:  tagnotidistanceKeyConstant)
        
        //defaults.set(false, forKey:  notiswitchKeyConstant)
        defaults.set(notificationswitch.isOn, forKey:  notiswitchKeyConstant)
    }
    
    func readData(){
            let defaults = UserDefaults.standard
            let name = defaults.string(forKey:  tagnameKeyConstant)
            let descriptions = defaults.string(forKey:  tagdescriptionKeyConstant)
            let notidistance = defaults.string(forKey:  tagnotidistanceKeyConstant)
            let notiswitchstate = defaults.bool(forKey:  notiswitchKeyConstant)
        
            tagnamefield.text = name
            tagdesciptionview.text = descriptions
    
            notificationswitch.setOn(notiswitchstate, animated: true)
        
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
