//
//  settingTableViewController.swift
//  FindMe
//
//  Created by DJuser on 4/8/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit

class settingTableViewController: UITableViewController {

    var setting: [String] = ["Notices","Help","About FindMe"]
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = setting[indexPath.row]
    
        return cell
    }
 
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? UITableViewCell
        let indexPath = tableView.indexPath(for: cell!)
        
        let dstVC : SettingDetailViewController = segue.destination as! SettingDetailViewController
        dstVC.settingTitle = setting[(indexPath?.row)!]
    }

    
    
    
}
