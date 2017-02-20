//
//  ViewController.swift
//  FindMe
//
//  Created by DJuser on 1/30/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController{
//UITabBardelegate
   
    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    
    // use to check user state -> unknown to logined user
    var authListener: FIRAuthStateDidChangeListenerHandle?
    
    let userref = FIRDatabase.database().reference().child("Users")
    
    @IBAction func logindidtouch(_ sender: Any) {
        
        if self.emailfield.text == "" || self.passwordfield.text == ""
        {
            let alertController = UIAlertController(title: "oops", message: "please enter email and password.", preferredStyle: .alert)
            let defaultaction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultaction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: self.emailfield.text!, password: self.passwordfield.text!, completion: {(user, error) in
                if error == nil
                {
                    self.emailfield.text = ""
                    self.passwordfield.text = ""
                    
                    self.performSegue(withIdentifier: "login", sender: nil)

                }
                else
                {
                    let alertController = UIAlertController(title: "oops", message: error?.localizedDescription , preferredStyle: .alert)
                    let defaultaction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultaction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
            
            
        }
        
    }

    
    @IBAction func signupdidtouch(_ sender: Any) {
    
        if self.emailfield.text == "" || self.passwordfield.text == ""
        {
            let alertController = UIAlertController(title: "oops", message: "please enter email and password.", preferredStyle: .alert)
            let defaultaction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultaction)
            self.present(alertController, animated: true, completion: nil)
        }
            
        else
        {
            FIRAuth.auth()?.createUser(withEmail: self.emailfield.text!, password: self.passwordfield.text!, completion: {(user, error) in
                
                if error == nil
                {
                    self.emailfield.text = ""
                    self.passwordfield.text = ""
                    
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
                else
                {
                    let alertController = UIAlertController(title: "oops", message: error?.localizedDescription , preferredStyle: .alert)
                    let defaultaction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultaction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
        }
    
    }
    
    
    @IBAction func forgetpassworddidtouch(_ sender: Any) {
    
        let resetPasswordAlert = UIAlertController(title: "Reset Password", message: nil, preferredStyle: .alert)
        resetPasswordAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter your email"
            textField.clearButtonMode = .whileEditing
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            let textField = resetPasswordAlert.textFields![0]
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: textField.text!) { error in
                if let error = error {
                   
                    AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
                
                } else {
                   
                    AppDelegate.showAlertMsg(withViewController: self, message: "Password reset email was sent")
                }
            }
            
        }
        
        resetPasswordAlert.addAction(cancelAction)
        resetPasswordAlert.addAction(confirmAction)
        self.present(resetPasswordAlert, animated: true, completion: nil)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authListener = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if user?.uid != nil{
                self.userref.child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    
                        if dictionary["username"] == nil {
                            self.performSegue(withIdentifier: "login", sender: nil)
                        
                        }else{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let TabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            appdelegate .window?.rootViewController = TabBarController
                        }
                    }
                }, withCancel: nil)
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let _ = IQKeyboardManager.sharedManager().resignFirstResponder()
        
        FIRAuth.auth()?.removeStateDidChangeListener(authListener!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}









