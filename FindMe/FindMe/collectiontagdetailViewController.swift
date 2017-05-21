//
//  collectiontagdetailViewController.swift
//  FindMe
//
//  Created by DJuser on 3/11/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import FirebaseDatabase
import IQKeyboardManagerSwift
import FirebaseStorage

class collectiontagdetailViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet weak var tagimage: UIImageView!
    
    @IBOutlet weak var tagnamefield: UITextField!
    @IBOutlet weak var tagdescriptionview: UITextView!
    @IBOutlet weak var notilabel: UILabel!
    @IBOutlet weak var notiswitch: UISwitch!
    @IBOutlet weak var notipicker: UIPickerView!
    
    var notirange: [String]!
    var selectedimage = UIImage()
    var Tagnotidistance = ""
    
    //*recieve data from locationViewController
    var detail = [String:String]()
    var tagdetailkey = String()
    
    var usertagid: String = ""

    //NSUser location
    var locationtagidKeyConstant = ""
    var locationtagnameKeyConstant = ""
    var locationtagdescriptionKeyConstant = ""
    var locationtagnotidistanceKeyConstant = ""
    var locationnotiswitchKeyConstant = ""
 
    var count = 0
    var check = 0

    let tagref = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if check != 1 {
            settagimgToView()
            check = 1
        }
        
        notipicker.frame = CGRect(x: 0, y: 430, width: self.view.bounds.width, height: 100)
        
        tagimage.image = selectedimage
        tagimage.center.x = self.view.center.x
        tagimage.center.y = 140
    
        //NSUser
        if selectedimage != nil && count != 1 {
            
            usertagid = detail["tagid"]!
            tagnamefield.text = detail["tagname"]
            tagdescriptionview.text = detail["tagdescription"]
            notilabel.text = detail["tagnotidistance"]
            count = 1
        
            locationtagidKeyConstant = detail["tagid"]!
            locationtagnameKeyConstant = "\(locationtagidKeyConstant)"+"tagnameKey"
            locationtagdescriptionKeyConstant = "\(locationtagidKeyConstant)"+"tagdescriptionKey"
            locationtagnotidistanceKeyConstant = "\(locationtagidKeyConstant)"+"tagnotidistanceKey"
            locationnotiswitchKeyConstant = "\(locationtagidKeyConstant)"+"notiswitchKey"
        
            writeData()
            
        }
        
        usertagid = detail["tagid"]!
        
        locationtagidKeyConstant = detail["tagid"]!
        locationtagnameKeyConstant = "\(locationtagidKeyConstant)"+"tagnameKey"
        locationtagdescriptionKeyConstant = "\(locationtagidKeyConstant)"+"tagdescriptionKey"
        locationtagnotidistanceKeyConstant = "\(locationtagidKeyConstant)"+"tagnotidistanceKey"
        locationnotiswitchKeyConstant = "\(locationtagidKeyConstant)"+"notiswitchKey"

        readData()
    }

    
    // retrieve data from database
    func settagimgToView() {
        FIRStorage.storage().reference(forURL: detail["imgurl"]!).data(withMaxSize: 10 * 1024 * 1024, completion: { (data, error) in
            self.tagimage.image = UIImage(data: data!)
        })
    }


    @IBAction func save(_ sender: Any) {
        
        let tagname = tagnamefield.text
        var tagdescribe = tagdescriptionview.text
        
        if tagdescribe == nil{
            tagdescribe = ""
        }
        
        let imageName = NSUUID().uuidString
        let storageref = FIRStorage.storage().reference().child("tags_images").child("\(imageName).png")
        let uploadtagimage = UIImagePNGRepresentation(tagimage.image!)
        let tagdetailref = self.tagref.child("TagsDetail/\(self.tagdetailkey)")
    
        storageref.put(uploadtagimage!, metadata: nil) { ( metadata, error) in
            
            let tagImageUrl = metadata?.downloadURL()?.absoluteString
            
            let tagdetailValue = [
                "tagid": self.usertagid,
                "TagName": tagname,
                "TagDescription": tagdescribe,
                "TagNotiDistance": self.Tagnotidistance,
                "tagurl": tagImageUrl,
                ] as [String : Any]
            
            tagdetailref.updateChildValues(tagdetailValue)
        }
        
        let alert = UIAlertController(title: "Edit your tag's detail completed", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion:{})
        
    }

    
    @IBAction func notididtouch(_ sender: Any) {
        if notiswitch.isOn {
            notipicker.showsSelectionIndicator = true
            notipicker.delegate = self
            notipicker.dataSource = self
            notirange = ["Immediate(0 - 20 cm.)", "Near(20 cm. - 2 m.)", "Far(2 - 30 m.)"]
            self.view.addSubview(notipicker)
            
        }
        else {
            notipicker.delegate = self
            notipicker.dataSource = self
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
        if notiswitch.isOn {
            notilabel.text = notirange[row]
            Tagnotidistance = notilabel.text!
        }
    }
    
    
    @IBAction func selecttagimage(_ sender: Any) {
        //NSUser
        writeData()

        self.performSegue(withIdentifier: "imgsymbol", sender: nil)
    }

    
    @IBAction func back(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let TagVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate .window?.rootViewController = TagVC
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var dstVC :  tagdetailImageCollectionViewController = segue.destination as! tagdetailImageCollectionViewController
        
        dstVC.detail = self.detail
        dstVC.recievetagdetailkey = self.tagdetailkey
        
        dstVC.recievecount = self.count
        dstVC.recievecheck = self.check
    }
    
    
    //NSUser
    func writeData()
    {
        let defaults = UserDefaults.standard
        defaults.set(tagnamefield.text, forKey:  locationtagnameKeyConstant)
        defaults.set(tagdescriptionview.text, forKey:  locationtagdescriptionKeyConstant)
        defaults.set(notilabel.text, forKey:  locationtagnotidistanceKeyConstant)
        defaults.set(true, forKey:  locationnotiswitchKeyConstant) 
    }
    
    func readData()
    {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey:  locationtagnameKeyConstant)
        let descriptions = defaults.string(forKey:  locationtagdescriptionKeyConstant)
        let notidistance = defaults.string(forKey:  locationtagnotidistanceKeyConstant)
        let notiswitchstate = defaults.bool(forKey:  locationnotiswitchKeyConstant)
        
        tagnamefield.text = name
        tagdescriptionview.text = descriptions
        notiswitch.setOn(notiswitchstate, animated: true)
        notilabel.text = notidistance
        
        if notidistance == nil{
        }
        else{
            if Tagnotidistance == "" {
                Tagnotidistance = notidistance!
            }
        }
    }


}

