//
//  EmojieViewController.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 9/20/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

protocol EmojieViewControllerDelegate: class {
    func imageUpdated(imageIndex: Int)
}

class EmojieViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var emojieCollectionView: UICollectionView!
    weak var delegate: EmojieViewControllerDelegate?
    
    var imagesArray:[UIImage] = []
    
    //36 30x30 cells
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojieCollectionView.delegate = self
        emojieCollectionView.dataSource = self
        
        emojieCollectionView.layer.cornerRadius = 10
        emojieCollectionView.clipsToBounds = true
        
        for i in 1...29 {
            guard let image = UIImage(named: "emojie_\(i).png") else {
                fatalError("Couldn't find image\(i).png")
            }
            imagesArray.append(image)
        }
        imagesArray.append(UIImage(named: "cancel.png")!)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        print("Selected \(indexPath.row)")
        if (indexPath.row != imagesArray.count-1) {
            self.delegate?.imageUpdated(imageIndex: indexPath.row)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojieCell", for: indexPath) as! PopupCollectionViewCell
        cell.imageView.image = imagesArray[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    

}
