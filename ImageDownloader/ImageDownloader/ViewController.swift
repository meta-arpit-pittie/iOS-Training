//
//  ViewController.swift
//  ImageDownloader
//
//  Created by Arpit Pittie on 2/17/17.
//  Copyright © 2017 Arpit Pittie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var changeImageButton: UIBarButtonItem!
    
    var selectedCell = [String]()
    
    var imageURLs = ["https://t3.ftcdn.net/jpg/00/58/01/74/240_F_58017459_v6F6Bb9BWgjvT8XTRSwgTTHxJPsl1pQn.jpg",
                     "https://i.ytimg.com/vi/XMZcjdK4Vuk/maxresdefault.jpg",
                     "http://www.powerpointhintergrund.com/uploads/computer-codes-technology-background-15.jpg",
                     "https://cdn.shutterstock.com/shutterstock/videos/4865030/thumb/1.jpg?i10c=img.resize(height:72)",
                     "https://i.ytimg.com/vi/5-LyRjHlRgQ/maxresdefault.jpg",
                     "http://previews.123rf.com/images/foxaon/foxaon1203/foxaon120300373/12927553-Dark-blue-technology-background-Stock-Photo-tech.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeImageButton.isEnabled = false
        imageCollectionView.allowsMultipleSelection = true
    }

    @IBAction func changeButtonAction(_ sender: UIBarButtonItem) {
        let dispatchGroup = DispatchGroup()
        for url in selectedCell {
            dispatchGroup.enter()
            
            imageURLs.append(url)
            imageCollectionView.reloadData()
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {[unowned self] in
            self.changeImageButton.isEnabled = false
            
            let alert = UIAlertController(title: "Copy Complete", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Close", style: .cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    func downloadImage(url: String, _ completionHandler:((_ success: Bool, _ error: Bool, _ data: Data?) -> ())?) {
        let imageURL = URL(string: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: imageURL!) {(data, response, error) in
            if error != nil {
                completionHandler!(false, true, nil)
            }
            if data == nil {
                completionHandler!(true, false, nil)
            } else {
                completionHandler!(true, false, data)
            }
        }
        task.resume()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        downloadImage(url: imageURLs[indexPath.row]) {(success, error, data) in
            if let imageData = data {
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: imageData)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeImageButton.isEnabled = true
        
        let cell = imageCollectionView.cellForItem(at: indexPath)
        cell?.selectedBackgroundView = UIImageView(image: UIImage(named: "photo-frame.png"))
        
        let url = imageURLs[indexPath.row]
        selectedCell.append(url)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let url = imageURLs[indexPath.row]
        
        let cell = imageCollectionView.cellForItem(at: indexPath)
        cell?.selectedBackgroundView = nil
        
        if let index = selectedCell.index(of: url) {
            selectedCell.remove(at: index)
        }
        
        if selectedCell.count == 0 {
            changeImageButton.isEnabled = false
        }
    }
}
