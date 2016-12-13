//
//  DisplayImageViewController.swift
//  Tabbed Application
//
//  Created by Arpit Pittie on 08/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController, UIScrollViewDelegate {

    // MARK: Properties
    @IBOutlet weak var scrollDisplay: UIScrollView!
    @IBOutlet weak var imageDisplay: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageDisplay.image = image

        scrollDisplay.minimumZoomScale = 1.0
        scrollDisplay.maximumZoomScale = 6.0
        
        scrollDisplay.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func doubleTapZoom(_ sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 2
        
        if scrollDisplay.zoomScale == 1 {
            scrollDisplay.setZoomScale(3, animated: true)
        }
        else {
            scrollDisplay.setZoomScale(1, animated: true)
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageDisplay
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
