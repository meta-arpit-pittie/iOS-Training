//
//  PageContentViewController.swift
//  PageApplication
//
//  Created by Arpit Pittie on 2/21/17.
//  Copyright © 2017 Arpit Pittie. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.image = UIImage(named: imageFile)
        titleLabel.text = titleText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundImageView.alpha = 0.0
    }
    
    func animateImage() {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .transitionFlipFromBottom, animations: {[unowned self] in
            self.backgroundImageView.alpha = 1.0
            }, completion: {[unowned self] (complete) in
                self.animateLabel()
        })
    }
    
    func animateLabel() {
        let bounds = titleLabel.bounds
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .beginFromCurrentState, animations: {[unowned self] in
            self.titleLabel.bounds = CGRect(x: bounds.origin.x - 30, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
        }, completion: nil)
    }

}
