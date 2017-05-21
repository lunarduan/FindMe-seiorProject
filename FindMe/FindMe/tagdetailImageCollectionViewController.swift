//
//  tagdetailImageCollectionViewController.swift
//  FindMe
//
//  Created by DJuser on 3/11/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit

private let reuseIdentifier = "tagcell"

class tagdetailImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tagarray : [UIImage] = []
    var selectedsymbol : UIImageView!
    var tag:String?
    
    //recive data from collectiontagdetailVC
    var detail = [String:String]()
    var recievetagdetailkey = String()
    var recievecount = Int()
    var recievecheck = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1..<24{
            
            let images = UIImage(named: "\(i).png")
            tagarray.append(images!)
        }
        
        selectedsymbol = UIImageView()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagarray.count
    }
    
    //cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //access cell which is stored in CollectionView and has ID "cell" -> reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! tagdeatilImgCollectionViewCell

        let img = UIImageView()
        img.image = tagarray[indexPath.row]
        img.sizeToFit()
        img.center = cell.contentView.center
        cell.contentView.addSubview(img)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //accessing header which is in CollectionView under ID "header"
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
        return header
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsize = (self.view.bounds.width)/4
        return CGSize(width: itemsize, height: itemsize)
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedsymbol.image = tagarray[indexPath.row]
        selectedsymbol.sizeToFit()
        
        //make alert box after select tag image
        let alert = UIAlertController(title: "select tag's image completed", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion:{})
        
        return true
    }
    
    
    // send tag image to previous viewcontroller(tagdetailViewContoller)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationdstVC : collectiontagdetailViewController = segue.destination as! collectiontagdetailViewController

        if selectedsymbol.image == nil{
            selectedsymbol.image = tagarray[0]
        }
        
        locationdstVC.selectedimage = self.selectedsymbol.image!
        locationdstVC.detail = self.detail
        locationdstVC.tagdetailkey = self.recievetagdetailkey
        locationdstVC.count = self.recievecount
        locationdstVC.check = self.recievecheck
    }
    
    
    @IBAction func backdidtouch(_ sender: Any) {
        self.performSegue(withIdentifier: "tagdetail", sender: nil)
    }
    
    
}
