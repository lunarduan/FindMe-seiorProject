//
//  TagImageSourceViewController.swift
//  AddNewTag
//
//  Created by DJuser on 1/24/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit

class TagImageSourceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    // back button to Tagdetail page
    @IBAction func backtotagdetail(_ sender: Any) {
        
        //refresh information in user default
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //let TagdetailVC = storyboard.instantiateViewController(withIdentifier: "TagdetailVC") as! TagDetailViewController
        let TagdetailVC = storyboard.instantiateViewController(withIdentifier: "NavigationViewController") as! UINavigationController

        // Get the app delegate
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Set Navigation Copntroller as root view controller
        appdelegate .window?.rootViewController = TagdetailVC
    
    }
    
    // called when press select from gallery button
    @IBAction func GallerySelected(_ sender: Any) {
        //called when press button under imageview
        let pickercontroller = UIImagePickerController()
        pickercontroller.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickercontroller.allowsEditing = true
        self.present(pickercontroller, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
