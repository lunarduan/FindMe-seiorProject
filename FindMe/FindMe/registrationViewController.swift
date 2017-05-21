//
//  registrationViewController.swift
//  FindMe
//
//  Created by DJuser on 1/31/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class registrationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {


    @IBOutlet weak var usernametextfiled: UITextField!
    @IBOutlet weak var emaillabel: UILabel!
    @IBOutlet weak var passwordlabel: UILabel!
    @IBOutlet weak var userprofileimage: UIImageView!
    @IBOutlet weak var userid: UILabel!
    @IBOutlet weak var dateofbirthlabel: UILabel!
    
    
    var uid:String = ""
    var email:String = ""
    var bdKeyConstant: String = ""
    
    let regisref = FIRDatabase.database().reference().child("Users")
    
    var birthdayDatePicker : UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser {
            setUserDataToView(withFIRUser: user)
        }

        birthdayDatePicker = UIDatePicker()
        birthdayDatePicker.frame = CGRect(x: 0, y: self.view.bounds.height - 160 , width: self.view.bounds.width, height: 80)
        birthdayDatePicker.addTarget(self, action: #selector(getDateAndTime), for: UIControlEvents.valueChanged)
        birthdayDatePicker.datePickerMode = UIDatePickerMode.date
        birthdayDatePicker.locale = Locale.current
        birthdayDatePicker.timeZone = TimeZone.current
        birthdayDatePicker.maximumDate = Date(timeIntervalSinceNow: 0)
        
        self.view.addSubview(birthdayDatePicker)

        readData()
    }
    
    
    func setUserDataToView(withFIRUser user: FIRUser) {
        emaillabel.text = user.email
        usernametextfiled.text = user.displayName
        userid.text = user.uid
        bdKeyConstant = userid.text!
    }
    
    
    func getDateAndTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"

        let dateString = dateFormatter.string(from: birthdayDatePicker.date)
        dateofbirthlabel.text = " \(dateString)"

        writeData()
    }
    
    
    @IBAction func logoutdidtouch(_ sender : Any) {
        try! FIRAuth.auth()!.signOut()
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate .window?.rootViewController = loginVC
    }
    
    
    @IBAction func selectuserimage(_ sender: Any) {
        let pickercontroller = UIImagePickerController()
        pickercontroller.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickercontroller.allowsEditing = true
    
        pickercontroller.delegate = self
        
        self.present(pickercontroller, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let images = info[UIImagePickerControllerEditedImage] as? UIImage
        dismiss(animated: true, completion: nil)

        userprofileimage.layer.cornerRadius = 20
        userprofileimage.layer.masksToBounds = true
        
        return  userprofileimage.image = images
    }
    
    
    @IBAction func startaction(_ sender: Any) {
        let imageName = NSUUID().uuidString
        let storageref = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
        let newuser = regisref.child(userid.text!)
    
        uid = userid.text!
        let username = usernametextfiled.text
        email = emaillabel.text!
        let dateofbirth = dateofbirthlabel.text
        
        let uploadtagimage = UIImagePNGRepresentation(userprofileimage.image!)
      
        storageref.put(uploadtagimage!, metadata: nil) { ( metadata, error) in
            let profileImageUrl = metadata?.downloadURL()?.absoluteString
            
            let uservalue = [
                "userid": self.uid,
                "username": username,
                "e-mail": self.email,
                "dateofbirth": dateofbirth,
                "userimageurl": profileImageUrl,
                ] as [String : Any]
            newuser.setValue(uservalue)
        }
        self.performSegue(withIdentifier: "tabbar", sender: nil)
    }
    

    func writeData()
    {
        let defaults = UserDefaults.standard
        defaults.set(dateofbirthlabel.text, forKey:  bdKeyConstant)
    }
    
    
    func readData()
    {
        let defaults = UserDefaults.standard
        let bd = defaults.string(forKey:  bdKeyConstant)
        dateofbirthlabel.text = bd
    }

    
}
