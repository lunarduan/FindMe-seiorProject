//
//  settingcontextViewController.swift
//  FindMe
//
//  Created by DJuser on 4/8/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit

class settingcontextViewController: UIViewController {

    
    @IBOutlet weak var mytext: UITextView!
    
   // var selectedtitle = String()
    var selectedindex = Int()
    
    var nothing : String = ""
    var help:[String] = ["The UUID, Major and Minor parameters are your tag iBeacon's identifier and make up the key component of the Advertising packets that are continually transmitted by your tag item.\n\nTheir value will display behide of your tag.", "There are 2 modes to find your lost item \n\n1. Outdoor mode : if your lost item is outside the building, \n    Application will show you the location of lost item on the map with latitude and longtitude. \n\n2. Indoor mode : If your lost item is inside the building, \n  Application will show you the location on the map and also show the distance and direction between you and your lost item.", "You can set Notification mode with 3 alternative distance \n\n1. Immediate about 0 - 20 cm.\n2. Near about 20 cm. - 2 m.\n3. Far about 2 - 30 m. \n\nAfter you set the available distance between you and your tag item, item lost protect mode will start working.\n\nBefore you will forget your tag item or your distance between tag item and you are nearly to notification setting distance, you will get the background message to remind you"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch selectedindex {
            case 1:
                mytext.text = help[0]
            case 2:
                mytext.text = help[1]
            case 3:
                mytext.text = help[2]
            default:
                nothing = ""
        }
    }


}
