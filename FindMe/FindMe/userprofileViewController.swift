//
//  userprofileViewController.swift
//  FindMe
//
//  Created by DJuser on 2/20/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class userprofileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        
    
    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet weak var userid: UILabel!
    @IBOutlet weak var emaillabel: UILabel!
    @IBOutlet weak var dateofbirthlabel: UILabel!

    @IBOutlet weak var userprofileimage: UIImageView!
    
    var birthdayDatePicker : UIDatePicker!
    var url: String = ""
    
    let userref = FIRDatabase.database().reference().child("Users")

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserDataToView(withFIRUser: (FIRAuth.auth()?.currentUser)!)
    }
    
    
    func setUserDataToView(withFIRUser user: FIRUser) {
        userref.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
        
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.usernamelabel.text = dictionary["username"] as! String?
                self.userid.text = dictionary["userid"] as! String?
                self.emaillabel.text = dictionary["e-mail"] as! String?
                self.dateofbirthlabel.text = dictionary["dateofbirth"] as! String?
                self.url = (dictionary["userimageurl"] as! String?)!
                    
                FIRStorage.storage().reference(forURL: self.url).data(withMaxSize: 10 * 1024 * 1024, completion: { (data, error) in
                        
                    self.userprofileimage.image = UIImage(data: data!)
                })

            }

        }, withCancel: nil)
        
    }


    @IBAction func editdidtouch(_ sender: Any) {
        performSelector(inBackground: #selector(edit), with: edit())
    }
    
    
    func edit() {
        let manageActionSheet = UIAlertController(title: "Select menu", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let changeUserInfoAction = UIAlertAction(title: "Change Username", style: .default) { (action: UIAlertAction) in
            self.changeUserInfo()
        }
            
        let changePasswordAction = UIAlertAction(title: "Change Password", style: .default) { (action: UIAlertAction) in
            self.changePassword()
        }
            
        let changeEmailAction = UIAlertAction(title: "Change Email", style: .default) { (action: UIAlertAction) in
               self.changeEmail()
        }
        
        let changeDateofBirthAction = UIAlertAction(title: "Change Date of Birth", style: .default) { (action: UIAlertAction) in
            self.changeDateofBirth()
        }
    
        let deleteAccountAction = UIAlertAction(title: "Delete Account", style: .default) { (action: UIAlertAction) in
            self.deleteAccount()
        }
            
        manageActionSheet.addAction(changeUserInfoAction)
        manageActionSheet.addAction(changePasswordAction)
        manageActionSheet.addAction(changeEmailAction)
        manageActionSheet.addAction(changeDateofBirthAction)
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
                self.usernamelabel.text = nameTextField.text
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
    
    
    func changeEmail() {
        let alert = UIAlertController(title: "Change Email", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter your new email"
            textField.clearButtonMode = .whileEditing
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            let emailTextField = alert.textFields![0]
            if let user = FIRAuth.auth()?.currentUser {
                self.emaillabel.text = emailTextField.text
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    

    func changeDateofBirth(){
        
        birthdayDatePicker = UIDatePicker()
        birthdayDatePicker.frame = CGRect(x: 10, y: 40, width: 250, height: 100)
        
        birthdayDatePicker.datePickerMode = UIDatePickerMode.date
        birthdayDatePicker.locale = Locale.current
        birthdayDatePicker.timeZone = TimeZone.current
        birthdayDatePicker.maximumDate = Date(timeIntervalSinceNow: 0)
        
        let alertController = UIAlertController(title: " \n\n\n\n\n", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.view.addSubview(birthdayDatePicker)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
           self.dateofbirthlabel.text = self.getDateAndTime()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion:{})
    }
    
    
    func getDateAndTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let dateString = dateFormatter.string(from: birthdayDatePicker.date)
        return "\(dateString)"
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
    
    
    @IBAction func selectuserimg(_ sender: Any) {
    
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
    

    @IBAction func saveaction(_ sender: Any) {

        let imageName = NSUUID().uuidString
        let storageref = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
        let newuser = userref.child(userid.text!)
            
        let uid = userid.text
        let username = usernamelabel.text
        let email = emaillabel.text
        let dateofbirth = dateofbirthlabel.text
            
        let uploadtagimage = UIImagePNGRepresentation(userprofileimage.image!)
            
        storageref.put(uploadtagimage!, metadata: nil) { ( metadata, error) in
            let profileImageUrl = metadata?.downloadURL()?.absoluteString
                
            let uservalue = [
                "userid": uid,
                "username": username,
                "e-mail": email,
                "dateofbirth": dateofbirth,
                "userimageurl": profileImageUrl,
            ] as [String : Any]
            newuser.setValue(uservalue)
        }
            
        let alert = UIAlertController(title: "Edit user profile completed", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion:{})
    }
    
    
    
}
