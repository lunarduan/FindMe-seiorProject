//
//  SettingDetailViewController.swift
//  FindMe
//
//  Created by DJuser on 4/8/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SettingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var settingTitle = String()
    
    var contents : [String] = []
    var date : [String] = []
    var helptitle: [String] = ["Frequently asked questions","What's UUID,Major,and Minor?.How can I find it?","How can I find my lost item?","How can I use notification mode.when it alert?"]
    var abouttitle: [String] = ["Current Version :","Contact FindMe team :"]
    var aboutdetail: [String] = ["1.0 Alpha", "findme_sup@gmail.com"]
    var no: String = ""
    
    var num : Int = 0
    var index : Int = 0
    
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = settingTitle
         /*
         let notice = [
         "date": "08-04-2017",
         "content": "Free!! avialable install to test at Senior",
         ] as [String : Any]
         FIRDatabase.database().reference().child("Notices").childByAutoId().setValue(notice)
         */
        
        fetchnoticesToView()
    }
    
    
    // retrieve data from database
    func fetchnoticesToView() {
        let ref = FIRDatabase.database().reference().child("Notices")
        
        ref.observe(.childAdded, with: { (snap) in
            ref.child("\(snap.key)").observe(.value, with: { (snapshots) in
                if let dictionary = snapshots.value as? [String: AnyObject] {
                    var noticeContent = dictionary["content"] as! String?
                    var noticeDate = dictionary["date"] as! String?
                    
                    self.contents.append(noticeContent!)
                    self.date.append(noticeDate!)
                    self.num += 1
                    
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                }
            })
        })
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch settingTitle {
            case "Notices":
                return num
            case "Help":
                return helptitle.count
            case "About FindMe":
                return abouttitle.count
            default:
                return 0
        }
        
        return 0
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! detailTableViewCell
        
        switch settingTitle {
            case "Notices":
                cell.mytitlelabel.text = contents[indexPath.row]
                cell.mysubtitlelabel.text = date[indexPath.row]
            case "Help":
                cell.mytitlelabel.text = helptitle[indexPath.row]
                cell.mysubtitlelabel.text = ""

            case "About FindMe":
                cell.mytitlelabel.text = abouttitle[indexPath.row]
                cell.mysubtitlelabel.text = aboutdetail[indexPath.row]
            
            default:
                cell.mytitlelabel.text = ""
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(settingTitle == "Notices"){
            //make alert box after select tag image
            let alert = UIAlertController(title: "Notice Detail", message: "\(contents[indexPath.row])", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion:{})
        }
        
        if(settingTitle == "Help"){
            index = indexPath.row
            self.performSegue(withIdentifier: "context", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let dstVC : settingcontextViewController = segue.destination as! settingcontextViewController
        dstVC.selectedindex = index
    }

    
}
