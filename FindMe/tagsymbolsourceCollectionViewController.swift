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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 1..<24{
            
            let images = UIImage(named: "\(i).png")
           tagarray.append(images!)
        }

        selectedsymbol = UIImageView()
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsize = (self.view.bounds.width)/6
        return CGSize(width: itemsize, height: itemsize)
    }
    

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedsymbol.image = tagarray[indexPath.row]
        selectedsymbol.sizeToFit()
        return true
    }

    // send tag image to previous viewcontroller(tagdetailViewContoller)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedsymbol.image == nil{
            selectedsymbol.image = tagarray[0]
        }
        var dstVC : tagdetailViewController = segue.destination as! tagdetailViewController
        dstVC.selectedimage = self.selectedsymbol.image!
    }

    
    @IBAction func backdidtouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
}
