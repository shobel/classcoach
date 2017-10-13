//
//  PopUpViewController.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 9/10/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

class PopUpViewController: UICollectionViewController  {
    
    var imagesArray:[UIImage] = []
    
    //36 30x30 cells
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 1...28 {
            guard let image = UIImage(named: "emojie_\(i).png") else {
                fatalError("Couldn't find image\(i).png")
            }
            imagesArray.append(image)
        }
       // imageView.animationImages = imagesArray
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojieCell", for: indexPath) as! PopupCollectionViewCell
        cell.imageView.image = imagesArray[indexPath.row]
        
        return cell
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
