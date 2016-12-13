//
//  SecondViewController.swift
//  Tabbed Application
//
//  Created by Arpit Pittie on 07/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import UIKit

class SecondViewController: UICollectionViewController {

    
    var images = [UIImage] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadImages()
        
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .horizontal
        collectionFlowLayout.itemSize = CGSize(width: 120, height: 120)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.minimumLineSpacing = 0
        
        collectionView!.collectionViewLayout = collectionFlowLayout
        
        collectionView!.delegate = self
        collectionView!.dataSource = self
        
        collectionView!.allowsMultipleSelection = true
        collectionView!.allowsSelection = true
    }
    
    // MARK: CollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        let pic = images[indexPath.row]
        
        cell.imageView.image = pic
        
        return cell
    }
    
    @IBAction func showOptionForDelete(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let position = sender.location(in: collectionView)
        
            let index = collectionView!.indexPathForItem(at: position)
        
            //let cell = collectionView!.cellForItem(at: index)
            images.remove(at: index!.row)
            collectionView!.reloadData()
        }
    }
    
    func loadImages() {
        images.append(UIImage(named: "pic1")!)
        images.append(UIImage(named: "pic2")!)
        images.append(UIImage(named: "pic3")!)
        images.append(UIImage(named: "pic4")!)
        images.append(UIImage(named: "pic5")!)
        images.append(UIImage(named: "pic6")!)
        images.append(UIImage(named: "pic7")!)
        images.append(UIImage(named: "pic8")!)
        images.append(UIImage(named: "pic9")!)
        images.append(UIImage(named: "pic10")!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imageDisplayView = segue.destination as! DisplayImageViewController
        
        if let selectedCell = sender as? ImageCollectionViewCell {
            let indexPath = collectionView!.indexPath(for: selectedCell)
            let selectedImage = images[indexPath!.row]
            
            imageDisplayView.image = selectedImage
        }
    }
}

