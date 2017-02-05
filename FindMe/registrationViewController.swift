//
//  registrationViewController.swift
//  FindMe
//
//  Created by DJuser on 1/31/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import FirebaseAuth

class registrationViewController: UIViewController {


    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet weak var emaillabel: UILabel!
    @IBOutlet weak var passwordlabel: UILabel!
    
    @IBOutlet weak var dateofbirthtextfield: UITextField!
    
    //var useremail = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser {
            setUserDataToView(withFIRUser: user)
        }
        
    }
    
    func setUserDataToView(withFIRUser user: FIRUser) {
        emaillabel.text = user.email
        usernamelabel.text = user.displayName
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

    
    @IBAction func startaction(_ sender: Any) {
        self.performSegue(withIdentifier: "tabbar", sender: nil)
    }
    
    
    
}
