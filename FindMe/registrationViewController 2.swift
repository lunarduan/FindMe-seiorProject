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


    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet weak var emaillabel: UILabel!
    @IBOutlet weak var passwordlabel: UILabel!
    
    @IBOutlet weak var userprofileimage: UIImageView!
    
    @IBOutlet weak var userid: UILabel!
    
    
    @IBOutlet weak var dateofbirthlabel: UILabel!
    var birthdayDatePicker : UIDatePicker!
    var dateofbirth:String = ""
    
    
    var uid:String = ""
    var username:String = ""
    var email:String = ""
    
    let regisref = FIRDatabase.database().reference().child("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser {
            setUserDataToView(withFIRUser: user)
        }
        
        // DatePicker Programmatically
        birthdayDatePicker = UIDatePicker()
        birthdayDatePicker.frame = CGRect(x: 0, y: 415, width: self.view.bounds.width, height: 100)
        birthdayDatePicker.addTarget(self, action: #selector(getDateAndTime), for: UIControlEvents.valueChanged)
        birthdayDatePicker.datePickerMode = UIDatePickerMode.date
        birthdayDatePicker.locale = Locale.current
        birthdayDatePicker.timeZone = TimeZone.current
       // birthdayDatePicker.date = Date(timeIntervalSince1970: 10)
        //birthdayDatePicker.minimumDate = Date(timeIntervalSince1970: 20)
        birthdayDatePicker.maximumDate = Date(timeIntervalSinceNow: 0)
        
        self.view.addSubview(birthdayDatePicker)
        
    }
    
    //NSUserdefault
   func writeButton()
    {
        let defaults = UserDefaults.standard
        defaults.set("defaultvalue", forKey: "userNameKey")
        
    }

    
    func setUserDataToView(withFIRUser user: FIRUser) {
        emaillabel.text = user.email
        usernamelabel.text = user.displayName
        userid.text = user.uid
    }
    
    // called when picker is changed
    func getDateAndTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
        // convert date from datePicker to String type
        let dateString = dateFormatter.string(from: birthdayDatePicker.date)
        dateofbirthlabel.text = " \(dateString)"

    }
    
    @IBAction func logoutdidtouch(_ sender : Any) {
        
        try! FIRAuth.auth()!.signOut()
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate .window?.rootViewController = loginVC
    }
    
    @IBAction func editaction(_ sender: UIBarButtonItem) {
        performSelector(inBackground: #selector(editdidtouch), with: editdidtouch())
        
    }

    func editdidtouch() {
        let manageActionSheet = UIAlertController(title: "Select menu", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let changeUserInfoAction = UIAlertAction(title: "Change username", style: .default) { (action: UIAlertAction) in
            self.changeUserInfo()
        }
        
        let changePasswordAction = UIAlertAction(title: "Change Password", style: .default) { (action: UIAlertAction) in
            self.changePassword()
        }
        
        let deleteAccountAction = UIAlertAction(title: "Delete Account", style: .default) { (action: UIAlertAction) in
            self.deleteAccount()
        }
        
        manageActionSheet.addAction(changeUserInfoAction)
        manageActionSheet.addAction(changePasswordAction)
        manageActionSheet.addAction(deleteAccountAction)
        manageActionSheet.addAction(cancelAction)
        
        self.present(manageActionSheet, animated: true, completion: nil)
    }

    
    func changeUserInfo() {
        let alert = UIAlertController(title: "Change your username", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter your username"
            textField.clearButtonMode = .whileEditing
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            let nameTextField = alert.textFields![0]
                if let user = FIRAuth.auth()?.currentUser {
                let changeRequest = user.profileChangeRequest()
                
                changeRequest.displayName = nameTextField.text

                changeRequest.commitChanges { error in
                    if let error = error {
                        AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                    } else {
                        AppDelegate.showAlertMsg(withViewController: self, message: "Your profile was updated")
                        self.setUserDataToView(withFIRUser: user)
                    }
                }
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func changePassword() {
        let alert = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter your new password"
            textField.clearButtonMode = .whileEditing
            textField.isSecureTextEntry = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            let textField = alert.textFields![0]
            let user = FIRAuth.auth()?.currentUser
            
            user?.updatePassword(textField.text!) { error in
                if let error = error {
                    AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                } else {
                    AppDelegate.showAlertMsg(withViewController: self, message: "Password was updated")
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func deleteAccount() {
        let alert = UIAlertController(title: "Delete Account", message: "This account will be deleted. This operation can not undo. Are you sure?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            
            if let user = FIRAuth.auth()?.currentUser {
                let alert = UIAlertController(title: "Delete Account", message: "[\(user.email!)] will be deleted. This operation can not undo. Are you sure?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
                    user.delete { error in
                        if let error = error {
                            AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                        
                        } else {
                            AppDelegate.showAlertMsg(withViewController: self, message: "[\(user.email!)] was deleted")
                            
                            try! FIRAuth.auth()!.signOut()
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            appdelegate .window?.rootViewController = loginVC
                        }
                    }
                }
                
                alert.addAction(cancelAction)
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func selectuserimage(_ sender: Any) {
        //called when press button under imageview
        let pickercontroller = UIImagePickerController()
        pickercontroller.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickercontroller.allowsEditing = true
        
        //ทำให้แสดงค่ารูปที่เลือกได้
        pickercontroller.delegate = self
        
        
        self.present(pickercontroller, animated: true, completion: nil)
        
    }
    
    //executed if image is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let images = info[UIImagePickerControllerEditedImage] as? UIImage
        dismiss(animated: true, completion: nil)
        
        //ทำให้รูปเป็นวงกลม
        userprofileimage.layer.cornerRadius = 20
        userprofileimage.layer.masksToBounds = true

        return  userprofileimage.image = images
        
    }
    
    
    @IBAction func startaction(_ sender: Any) {
        
        let imageName = NSUUID().uuidString
        
        let storageref = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
    
        let newuser = regisref.child(userid.text!)
        
        uid = userid.text!
        username = usernamelabel.text!
        email = emaillabel.text!
        dateofbirth = dateofbirthlabel.text!
        
        
        let uploadtagimage = UIImagePNGRepresentation(userprofileimage.image!)
      
        storageref.put(uploadtagimage!, metadata: nil) { ( metadata, error) in
            let profileImageUrl = metadata?.downloadURL()?.absoluteString
            
            let uservalue = [
                "userid": self.uid,
                "username": self.username,
                "e-mail": self.email,
                "dateofbirth": self.dateofbirth,
                "userimageurl": profileImageUrl,
                ] as [String : Any]
            newuser.setValue(uservalue)
        }
    
        self.performSegue(withIdentifier: "tabbar", sender: nil)
    
    }
    

    
}
