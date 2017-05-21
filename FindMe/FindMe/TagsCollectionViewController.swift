//
//  TagsCollectionViewController.swift
//  FindMe
//
//  Created by DJuser on 3/5/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

private let reuseIdentifier = "Cell"

class TagsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var testimg: UIImageView!
    
    var tagimgcollectionarray : [UIImage] = []
    var tagimagurlarray : [String??] = []
    
    var usertagkeyarray : [String] = []
    var usertagkey : String = ""
    var tagkey : String = ""  
    var tagkeyarray : [String] = []
    
    var imgurl : String?
    var selectedtagimg : UIImageView?
    var selectedtagdata : [String:String?] = [:]
    var userdetailarray : [[String:String?]] = []

    
    var numimgs : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let user = FIRAuth.auth()?.currentUser {
            fetchtags(withFIRUser: user)
            fetchtagdetail()
        }
        
        //long press to delete object
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(TagsCollectionViewController.handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
       
        self.collectionView?.reloadData()
    }
    
    
    //long press to delete object
    func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
            return
        }
        
        let p = gestureRecognizer.location(in: self.collectionView)
        
        if let indexPaths : IndexPath = (self.collectionView?.indexPathForItem(at: p))! as IndexPath?{
 
            var removedkey = tagkeyarray[indexPaths.row]

            //make alert box after select tag image
            let alert = UIAlertController(title: "Delete tag", message: "Do you want to delete this tag?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
               
                if let user = FIRAuth.auth()?.currentUser {
                    
                    var ref =  FIRDatabase.database().reference().child("TagsDetail")

                    ref.child("\(removedkey)").observe(.value, with: { (snapshot) in
                        
                        
                        if let dict = snapshot.value as? [String : AnyObject]{
                            var id = dict["tagid"] as! String
                            
                            FIRDatabase.database().reference().child("Tags").child("\(id)").removeValue()
                            FIRDatabase.database().reference().child("locations").child("\(id)").removeValue()
                            FIRDatabase.database().reference().child("TagsDetail").child("\(removedkey)").removeValue()
        
                            self.collectionView?.performBatchUpdates({ Void in
                               // self.collectionView?.deleteItems(at: selectedindexpaths as [IndexPath])
                                self.collectionView?.deleteItems(at: [indexPaths as IndexPath as IndexPath])
                                self.tagimagurlarray.remove(at: indexPaths.row)
                                self.numimgs -= 1
                                
                            }, completion: nil)

                            
                            DispatchQueue.main.async {
                                self.collectionView?.reloadData()
                            }
                            
                        }
                    })
                    
                
                    //alert box
                    let alert = UIAlertController(title: "delete tag completed", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)

                    
                }
            }

           
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
 
        }
        
    }

    
    //get tag key
    func fetchtags(withFIRUser user: FIRUser){
        FIRDatabase.database().reference().child("Tags").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var userids = dictionary["userid"] as! String?
                
                if userids == user.uid {
   
                    self.usertagkey = snapshot.key
                    
                    self.usertagkeyarray.append(self.usertagkey)
                    
                    let usertagvalue = [
                        "taguuid": (dictionary["uuid"] as! String?),
                        "tagmajor": (dictionary["major"] as! String?),
                        "tagminor": (dictionary["minor"] as! String?),
                        ] as [String : Any]
                    
                }
            }
            
        }, withCancel: nil)
    }

    
    // get tag image url and append image to tagimgcollectionarray
    func fetchtagdetail(){
        FIRDatabase.database().reference().child("TagsDetail").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var tagid = dictionary["tagid"] as! String?

                for (index,key) in self.usertagkeyarray.enumerated() {
                    
                    if tagid == key {
                        
                        
                        let usertagdetail = [
                            "tagid": (dictionary["tagid"] as! String?),
                            "tagdescription": (dictionary["TagDescription"] as! String?),
                            "tagname": (dictionary["TagName"] as! String?)!,
                            "tagnotidistance": (dictionary["TagNotiDistance"] as! String?),
                            "imgurl": (dictionary["tagurl"] as! String?),
                        ]
                        
                        self.imgurl = (usertagdetail["imgurl"] as! String??)!
                        self.tagimagurlarray.append(self.imgurl!)
                        
                        
                        FIRStorage.storage().reference(forURL: self.imgurl!).data(withMaxSize: 10 * 1024 * 1024, completion: { (data, error) in
                            
                            let images = UIImage(data: data!)!
                            self.tagimgcollectionarray.append(images)
                            
                            
                            self.userdetailarray.append(usertagdetail)
                            
                            self.tagkey = snapshot.key    //duan 11/03
                            self.tagkeyarray.append(self.tagkey)//duan 11/03
                            
                            //longpress
                            self.numimgs += 1
                            
                            DispatchQueue.main.async{
                                self.collectionView?.reloadData()
                            }
                        
                        })

                    }
                }
            }
            
        }, withCancel: nil)
        
    }
  
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numimgs
    }
    

    //cel config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //access cell which is stored in tagimageCollectionViewCell and has ID "Cell" -> reuseIdentifier
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! tagimageCollectionViewCell
    
        let img = UIImageView()
        img.image = self.tagimgcollectionarray[indexPath.row]
        img.sizeToFit()
        img.center = Cell.contentView.center
        Cell.contentView.addSubview(img)

        return Cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsize = (self.view.bounds.width)/6
        return CGSize(width: itemsize, height: itemsize)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        selectedtagimg?.image = tagimgcollectionarray[indexPath.row]
        selectedtagimg?.sizeToFit()
        selectedtagdata = userdetailarray[indexPath.row]
        tagkey = tagkeyarray[indexPath.row]
        
        self.performSegue(withIdentifier: "location", sender: nil)
        
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //accessing header which is in CollectionView under ID "Header"
        let Header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Head", for: indexPath)
        return Header
    }
 

   
    // send tag data to locationViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var dstVC : locationViewController = segue.destination as! locationViewController
        dstVC.tagselecteddetail = selectedtagdata as! [String : String]
        dstVC.selectedtagdetailkey = self.tagkey // duan 11/03
    }
  
    @IBAction func lougout(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logout = storyboard.instantiateViewController(withIdentifier: "ViewController") as!ViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate .window?.rootViewController = logout
    }
    
    
    
}
