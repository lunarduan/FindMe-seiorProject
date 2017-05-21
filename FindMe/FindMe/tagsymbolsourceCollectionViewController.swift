//
//  tagsymbolsourceCollectionViewController.swift
//  FindMe
//
//  Created by DJuser on 1/31/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class tagsymbolsourceCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var tagarray : [UIImage] = []
    var selectedsymbol : UIImageView!
    var tag:String?
    
    var checknd:Int?
    
    
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

    //cel config
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //access cell which is stored in CollectionView and has ID "cell" -> reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        let img = UIImageView()
        img.image = tagarray[indexPath.row]
        img.sizeToFit()
        img.center = cell.contentView.center
        cell.contentView.addSubview(img)
    
        return cell
   }

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //accessing header which is in CollectionView under ID "header"
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        return header
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsize = (self.view.bounds.width)/6
        return CGSize(width: itemsize, height: itemsize)
    }*/
    

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
        if selectedsymbol.image == nil{
            selectedsymbol.image = tagarray[0]
        }
    
        if checknd == 0 {
            let locationdstVC : collectiontagdetailViewController = segue.destination as! collectiontagdetailViewController
            locationdstVC.selectedimage = self.selectedsymbol.image!
            locationdstVC.usertagid = self.tag!
        }
        
        if checknd != 0 {
            let dstVC : tagdetailViewController = segue.destination as! tagdetailViewController
            dstVC.selectedimage = self.selectedsymbol.image!
            dstVC.usertagid = self.tag!
        }
    
    }

    
    @IBAction func backdidtouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
