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
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageDisplay.image = image

        scrollDisplay.minimumZoomScale = 1.0
        scrollDisplay.maximumZoomScale = 6.0
        
        scrollDisplay.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        let widthScale = view.bounds.size.width / imageDisplay.bounds.width
        let heightScale = view.bounds.size.height / imageDisplay.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollDisplay.minimumZoomScale = minScale
        
        scrollDisplay.zoomScale = minScale
        
        scrollViewDidZoom(scrollDisplay)
    }
    
    // MARK: Actions
    
    @IBAction func doubleTapZoom(_ sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 2
        
        if scrollDisplay.zoomScale == scrollDisplay.minimumZoomScale {
            scrollDisplay.setZoomScale(scrollDisplay.minimumZoomScale + 2, animated: true)
        }
        else {
            scrollDisplay.setZoomScale(scrollDisplay.minimumZoomScale, animated: true)
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageDisplay
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let yOffset = max(0, (view.bounds.size.height - imageDisplay.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (view.bounds.size.width - imageDisplay.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
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
