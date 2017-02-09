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
    
    
    let ref = FIRDatabase.database().reference().child("TagsDetail")
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        notificationpickerview.frame = CGRect(x: 0, y: 430, width: self.view.bounds.width, height: 100)
        
        mypic.image = selectedimage
        mypic.sizeToFit()
        mypic.center.x = self.view.center.x
        mypic.center.y = 140
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var dstVC :  tagsymbolsourceCollectionViewController = segue.destination as! tagsymbolsourceCollectionViewController
        dstVC.tag = self.usertagid
    }

    
    //when Done button pressed, app will sent data to firebase database
    @IBAction func donedidtouch(_ sender: Any) {
       
        //try to access auto key
        //let tagref = FIRDatabase.database().reference().child("Tags")
    
        //tagref.queryOrdered(byChild: "major").observe(.childAdded, with: { snapshot in
            //print all key that have key major
          //  print("key...............\(snapshot.key)................")
        
       // })
        
        //ใช้ไม่ได้เพราะค่าtmajor จะมีค่าแค่ในviewdidload
        //tagref.queryOrdered(byChild: "major").queryEqual(toValue: tmajor).observe(.value, with: { snapshot in
            //ค่าออกแล้วแต่majorต้องต่างกัน ตรง queryEqual(toValue: tmajor) ค่าtmajorผิด ถ้าเปลี่ยนเป้นตัวเลขจะปริ้นค่าได้ถูก
            //print("get in major naja")
              //  for child in snapshot.children {
                //    let keys = (child as AnyObject).key as String
                   // print("key for major:\(self.tmajor)..........\(keys)...............")
               // }
       // })
        //
        
        
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
