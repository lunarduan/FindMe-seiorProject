//
//  tagsTableViewController.swift
//  FindMe
//
//  Created by DJuser on 3/6/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class tagsTableViewController: UITableViewController {

    var usertagkey : String = ""
    var usertagkeyarray : [String] = []
    
    var tagnames : [String] = []
    
    var tags : [String] = []
    
    var imgurl : String?
    var tagimagurlarray : [String] = []
    var tagimgcollectionarray : [UIImage] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser {
            fetchtags(withFIRUser: user)
            fetchtagdetail()
           
        }
    }

    //get tag key
    func fetchtags(withFIRUser user: FIRUser){
        FIRDatabase.database().reference().child("Tags").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var userid = dictionary["userid"] as! String?
                
                if userid! == user.uid {
                    
                    self.usertagkey = snapshot.key
                    
                    print("tag key : \(self.usertagkey)")
                    self.usertagkeyarray.append(self.usertagkey)
                    
                    let usertagvalue = [
                        "taguuid": (dictionary["uuid"] as! String?)!,
                        "tagmajor": (dictionary["major"] as! Int?)!,
                        "tagminor": (dictionary["minor"] as! Int?)!,
                        ] as [String : Any]
                    
                    print(self.usertagkeyarray)
                    print("\n")
                    
                }
            }
            
        }, withCancel: nil)
    }
    
    
    // get tag image url
    func fetchtagdetail(){
        
        FIRDatabase.database().reference().child("TagsDetail").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var tagid = dictionary["tagid"] as! String?
                
                for (index,key) in self.usertagkeyarray.enumerated() {
                    
                    if tagid == key {
                        print(".....tag ok....")
                        print(tagid!)
                        
                        let usertagdetail = [
                            "tagdescription": (dictionary["TagDescription"] as! String?)!,
                            "tagname": (dictionary["TagName"] as! String?)!,
                            "tagnotidistance": (dictionary["TagNotiDistance"] as! String?)!,
                            "imgurl": (dictionary["tagurl"] as! String?)!,
                            ]
                        
                        self.imgurl = (usertagdetail["imgurl"] as! String?)!
                        self.tagimagurlarray.append(self.imgurl!)
                        
                        var url = self.imgurl as! URL
                        
                        self.downloadImage(url: url)
                        
                        
                        
                        /*
                        //ในนี้มีค่าแต่ข้างนอกไม่มีค่า
                        FIRStorage.storage().reference(forURL: self.imgurl!).data(withMaxSize: 10 * 1024 * 1024, completion: { (data, error) in
                            //self.tagimage.image = UIImage(data: data!)
                            
                            let images = UIImage(data: data!)!
                            self.tagimgcollectionarray.append(images)
                            
                            //print(self.tagimgcollectionarray.count)
                            
                        })
                        */
                      
                        
                    }
                }
            }
            
        }, withCancel: nil)
        
        print(self.tagimgcollectionarray.count)

    }
    
    
    
    func getDataFromUrl(url: URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
        }.resume()
        
    }
    
    func downloadImage(url: URL){
        print("Download Started")
        
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() { () -> Void in
                print(response?.suggestedFilename ?? url.lastPathComponent ?? "")
                print("Download Finished")
                let images = UIImage(data: data)
                self.tagimgcollectionarray.append(images!)

            }
        }
    
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //number of row in tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagimgcollectionarray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)

        // Configure the cell...
        //cell.textLabel?.text = tagnames[indexPath.row]  //indexpath.row means index of each row
        cell.imageView?.image = tagimgcollectionarray[indexPath.row]
        
        return cell
    }
    

    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
